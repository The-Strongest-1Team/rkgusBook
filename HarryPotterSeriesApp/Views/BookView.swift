import UIKit
import SnapKit

// 이벤트 전달을 위한 프로토콜
protocol BookViewDelegate: AnyObject {
    func didTapSeriesButton(index: Int)
    func didTapSummaryToggle(index: Int)
}

// 책 정보
final class BookView: UIView {
    weak var delegate: BookViewDelegate?

    // 헤더 타이틀
    lazy var headerTitleLabel = createLabel(font: .boldSystemFont(ofSize: 24), textColor: .black, numberOfLines: 0, textAlignment: .center)

    // 시리즈 번호 버튼 수평 스택뷰
    lazy var seriesButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    // 스크롤이 가능한 컨테이너
    let scrollView = UIScrollView()
    
    // 수직 스택뷰
    let contentStackView = UIStackView()

    // 책 이미지
    lazy var bookImageView = createImageView(contentMode: .scaleAspectFill, cornerRadius: 0, backgroundColor: .lightGray)
    
    // 책 제목
    lazy var titleLabel = createLabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0)

    // 작가 정보
    lazy var authorTitleLabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .black, text: "Author")
    lazy var authorLabel = createLabel(font: .systemFont(ofSize: 18), textColor: .darkGray)

    // 발매일 정보
    lazy var releaseTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Released")
    lazy var releaseLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    // 페이지 수
    lazy var pagesTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Pages")
    lazy var pagesLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    // 헌정사
    lazy var dedicationTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Dedication")
    lazy var dedicationLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)

    // 요약
    lazy var summaryTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Summary")
    lazy var summaryLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)

    // 요약 더보기/접기 버튼
    lazy var summaryToggleButton = createButton(titleColor: .systemBlue, backgroundColor: .clear, font: .systemFont(ofSize: 14), cornerRadius: 0)

    // 버튼 오른쪽 정렬
    lazy var summaryButtonContainer: UIView = {
        let view = UIView()
        view.addSubview(summaryToggleButton)
        summaryToggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        return view
    }()

    // 챕터 목록
    lazy var chaptersTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Chapters")
    lazy var chaptersStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    // 전체 메인 레이아웃
    lazy var mainStackView = createStackView(axis: .horizontal, spacing: 20, alignment: .top)
    lazy var textStackView = createStackView(axis: .vertical, spacing: 12, alignment: .leading)

    // 텍스트 정보 묶기
    lazy var authorStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var releaseStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var pagesStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)

    // VStack
    lazy var dedicationStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)
    lazy var summaryStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    // Summary 확장 상태 저장용
    private var fullSummaryText: String = ""
    private var isExpanded: Bool = false
    private let characterLimit = 450 // 최대 표시 글자 수

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        configureContentPriorities()
        scrollView.showsVerticalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 시리즈 버튼 동적 생성
    func setupSeriesButtons(count: Int) {
        for i in 0..<count {
            let button = UIButton(type: .system)
            button.setTitle("\(i + 1)", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .lightGray
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.tag = i
            button.addTarget(self, action: #selector(didTapSeriesButton(_:)), for: .touchUpInside)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            seriesButtonsStackView.addArrangedSubview(button)
        }
    }

    // 시리즈 버튼 탭 이벤트 처리 → ViewController로 전달
    @objc private func didTapSeriesButton(_ sender: UIButton) {
        delegate?.didTapSeriesButton(index: sender.tag)
    }

    // 시리즈 버튼 UI 강조
    func highlightSelectedButton(at index: Int) {
        for (i, view) in seriesButtonsStackView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            button.backgroundColor = (i == index) ? .systemBlue : .systemGray5
            button.setTitleColor((i == index) ? .white : .systemBlue, for: .normal)
        }
    }

    // 챕터 목록 업데이트
    func updateChapters(_ chapters: [String]) {
        chaptersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 제거
        for chapter in chapters {
            let label = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
            label.text = chapter
            chaptersStackView.addArrangedSubview(label)
        }
    }

    // 요약 텍스트, 확장 상태
    func updateSummary(_ summary: String, bookIndex: Int) {
        fullSummaryText = summary
        let savedState = UserDefaults.standard.bool(forKey: "summaryExpanded_\(bookIndex)")
        isExpanded = savedState
        updateSummaryDisplay()
    }

    // 요약 더보기/접기 토글
    func toggleSummary(bookIndex: Int) {
        isExpanded.toggle()
        UserDefaults.standard.set(isExpanded, forKey: "summaryExpanded_\(bookIndex)")
        updateSummaryDisplay()
    }

    // 요약 텍스트를 전체 표시할지 잘라서 표시할지
    private func updateSummaryDisplay() {
        let needsToggle = fullSummaryText.count > characterLimit

        if needsToggle {
            if isExpanded {
                summaryLabel.text = fullSummaryText
                summaryToggleButton.setTitle("접기", for: .normal)
                summaryToggleButton.isHidden = false
            } else {
                let truncatedText = String(fullSummaryText.prefix(characterLimit)) + "..."
                summaryLabel.text = truncatedText
                summaryToggleButton.setTitle("더보기", for: .normal)
                summaryToggleButton.isHidden = false
            }
        } else {
            summaryLabel.text = fullSummaryText
            summaryToggleButton.isHidden = true
        }
    }
}
