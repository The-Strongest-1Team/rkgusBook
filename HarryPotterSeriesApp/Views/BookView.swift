import UIKit
import SnapKit

protocol BookViewDelegate: AnyObject {
    func didTapSeriesButton(index: Int)
    func didTapSummaryToggle(index: Int)
}

final class BookView: UIView {
    weak var delegate: BookViewDelegate?

    lazy var headerTitleLabel = createLabel(font: .boldSystemFont(ofSize: 24), textColor: .black, numberOfLines: 0, textAlignment: .center)

    lazy var seriesButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    lazy var bookImageView = createImageView(contentMode: .scaleAspectFill, cornerRadius: 0, backgroundColor: .lightGray)
    lazy var titleLabel = createLabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0)

    lazy var authorTitleLabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .black, text: "Author")
    lazy var authorLabel = createLabel(font: .systemFont(ofSize: 18), textColor: .darkGray)

    lazy var releaseTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Released")
    lazy var releaseLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    lazy var pagesTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Pages")
    lazy var pagesLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    lazy var dedicationTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Dedication")
    lazy var dedicationLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)

    lazy var summaryTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Summary")
    lazy var summaryLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
    lazy var summaryToggleButton = createButton(titleColor: .systemBlue, backgroundColor: .clear, font: .systemFont(ofSize: 14), cornerRadius: 0)

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

    lazy var chaptersTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Chapters")
    lazy var chaptersStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    lazy var mainStackView = createStackView(axis: .horizontal, spacing: 20, alignment: .top)
    lazy var textStackView = createStackView(axis: .vertical, spacing: 12, alignment: .leading)

    lazy var authorStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var releaseStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var pagesStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)

    lazy var dedicationStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)
    lazy var summaryStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    private var fullSummaryText: String = ""
    private var isExpanded: Bool = false
    private let characterLimit = 450

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

    @objc private func didTapSeriesButton(_ sender: UIButton) {
        delegate?.didTapSeriesButton(index: sender.tag)
    }

    func highlightSelectedButton(at index: Int) {
        for (i, view) in seriesButtonsStackView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            button.backgroundColor = (i == index) ? .systemBlue : .systemGray5
            button.setTitleColor((i == index) ? .white : .systemBlue, for: .normal)
        }
    }

    func updateChapters(_ chapters: [String]) {
        chaptersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for chapter in chapters {
            let label = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
            label.text = chapter
            chaptersStackView.addArrangedSubview(label)
        }
    }

    func updateSummary(_ summary: String, bookIndex: Int) {
        fullSummaryText = summary
        let savedState = UserDefaults.standard.bool(forKey: "summaryExpanded_\(bookIndex)")
        isExpanded = savedState
        updateSummaryDisplay()
    }

    func toggleSummary(bookIndex: Int) {
        isExpanded.toggle()
        UserDefaults.standard.set(isExpanded, forKey: "summaryExpanded_\(bookIndex)")
        updateSummaryDisplay()
    }

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
