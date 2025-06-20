import UIKit

final class BookViewController: UIViewController {
    
    private let bookView = BookView()
    private let viewModel = BookViewModel()
    
    override func loadView() {
        view = bookView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupActions()
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
        bookView.seriesNumberButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        bookView.summaryToggleButton.addTarget(self, action: #selector(didTapSummaryToggle), for: .touchUpInside)
    }

    private func updateUI(_ book: Book) {
        bookView.headerTitleLabel.text = book.title
        bookView.titleLabel.text = book.title
        bookView.authorLabel.text = book.author
        bookView.pagesLabel.text = "\(book.pages)"
        bookView.releaseLabel.text = viewModel.formattedDate() ?? book.release_date
        bookView.bookImageView.image = UIImage(named: "harrypotter\(viewModel.currentIndex + 1)")
        bookView.seriesNumberButton.setTitle("\(viewModel.currentIndex + 1)", for: .normal)
        bookView.dedicationLabel.text = book.dedication
        
        bookView.updateSummary(book.summary, bookIndex: viewModel.currentIndex)

        let chapterTitles = book.chapters?.map { $0.title } ?? []
        bookView.updateChapters(chapterTitles)
    }

    @objc private func didTapNext() {
        viewModel.nextBook()
    }
    
    @objc private func didTapSummaryToggle() {
        bookView.toggleSummary(bookIndex: viewModel.currentIndex)
    }

    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    BookViewController()
}
