import UIKit

final class BookViewController: UIViewController {
    private let bookView = BookView()
    private let viewModel = BookViewModel()

    // SafeArea에 맞게 배치
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(bookView)

        bookView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookView.delegate = self // 뷰에서 발생한 액션을 컨트롤러가 처리할 수 있게 연결
        setupBindings() // ViewModel → ViewController 데이터 흐름 설정
        setupActions() // 액션 연결
        bookView.setupSeriesButtons(count: 7) // 시리즈 7권 버튼 생성
        viewModel.fetchBooks() // 책 정보 로드
    }

    // 콜백 바인딩 설정
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self, let book = self.viewModel.currentBook else { return }
            self.updateUI(book) // 책 데이터가 바뀌면 UI 갱신
        }

        viewModel.onError = { [weak self] error in
            self?.presentAlert(message: error)
        }
    }

    // 버튼 클릭 액션 연결
    private func setupActions() {
        bookView.summaryToggleButton.addTarget(self, action: #selector(didTapSummaryToggleButton), for: .touchUpInside)
    }

    // 현재 책 데이터로 갱신
    private func updateUI(_ book: Book) {
        bookView.headerTitleLabel.text = book.title
        bookView.titleLabel.text = book.title
        bookView.authorLabel.text = book.author
        bookView.pagesLabel.text = "\(book.pages)"
        bookView.releaseLabel.text = viewModel.formattedDate() ?? book.release_date // 날짜 포맷팅
        bookView.bookImageView.image = UIImage(named: "harrypotter\(viewModel.currentIndex + 1)") // 책 이미지 설정
        bookView.highlightSelectedButton(at: viewModel.currentIndex) // 선택된 시리즈 버튼 강조
        bookView.dedicationLabel.text = book.dedication
        bookView.updateSummary(book.summary, bookIndex: viewModel.currentIndex) // 요약 표시

        let chapterTitles = book.chapters?.map { $0.title } ?? [] // 챕터 타이틀 배열 추출
        bookView.updateChapters(chapterTitles) // 챕터 리스트 업데이트
    }

    // 요약 더보기/접기 버튼 클릭 시 실행되는 메서드
    @objc private func didTapSummaryToggleButton() {
        bookView.toggleSummary(bookIndex: viewModel.currentIndex)
    }

    // 에러 메시지 UIAlertController로 표시
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// 사용자 인터랙션 처리
extension BookViewController: BookViewDelegate {
    // 시리즈 버튼 클릭 시 해당 인덱스의 책으로 전환
    func didTapSeriesButton(index: Int) {
        viewModel.setBook(at: index)
    }

    // 요약 더보기/접기 버튼 클릭 처리
    func didTapSummaryToggle(index: Int) {
        bookView.toggleSummary(bookIndex: index)
    }
}

#Preview {
    BookViewController()
}
