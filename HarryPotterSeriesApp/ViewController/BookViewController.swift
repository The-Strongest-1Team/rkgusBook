import UIKit

final class BookViewController: UIViewController {
    private let bookView = BookView()
    private let viewModel = BookViewModel()

    override func loadView() {
        view = bookView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookView.delegate = self
        setupBindings()
        setupActions()
        bookView.setupSeriesButtons(count: 7)
        viewModel.fetchBooks()
    }

    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self, let book = self.viewModel.currentBook else { return }
            self.updateUI(book)
        }

        viewModel.onError = { [weak self] error in
            self?.presentAlert(message: error)
        }
    }

    private func setupActions() {
        bookView.summaryToggleButton.addTarget(self, action: #selector(didTapSummaryToggleButton), for: .touchUpInside)
    }

    private func updateUI(_ book: Book) {
        bookView.headerTitleLabel.text = book.title
        bookView.titleLabel.text = book.title
        bookView.authorLabel.text = book.author
        bookView.pagesLabel.text = "\(book.pages)"
        bookView.releaseLabel.text = viewModel.formattedDate() ?? book.release_date
        bookView.bookImageView.image = UIImage(named: "harrypotter\(viewModel.currentIndex + 1)")
        bookView.highlightSelectedButton(at: viewModel.currentIndex)
        bookView.dedicationLabel.text = book.dedication
        bookView.updateSummary(book.summary, bookIndex: viewModel.currentIndex)

        let chapterTitles = book.chapters?.map { $0.title } ?? []
        bookView.updateChapters(chapterTitles)
    }

    @objc private func didTapSummaryToggleButton() {
        bookView.toggleSummary(bookIndex: viewModel.currentIndex)
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension BookViewController: BookViewDelegate {
    func didTapSeriesButton(index: Int) {
        viewModel.setBook(at: index)
    }

    func didTapSummaryToggle(index: Int) {
        bookView.toggleSummary(bookIndex: index)
    }
}

#Preview {
    BookViewController()
}
