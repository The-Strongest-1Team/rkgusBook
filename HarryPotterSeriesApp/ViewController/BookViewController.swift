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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bookView.headerTitleLabel.preferredMaxLayoutWidth = view.frame.width - 32
        bookView.titleLabel.preferredMaxLayoutWidth = bookView.titleLabel.frame.width
    }
    
    private func setupBindings() {
        viewModel.bindBookToView = { [weak self] in
            guard let self = self, let book = self.viewModel.currentBook else { return }
            self.updateUI(with: book)
        }
        
        viewModel.bindError = { [weak self] errorMessage in
            self?.showErrorAlert(message: errorMessage)
        }
    }
    
    private func setupActions() {
        bookView.seriesNumberButton.addTarget(self, action: #selector(seriesButtonTapped), for: .touchUpInside)
    }
    
    private func updateUI(with book: Book) {
        bookView.headerTitleLabel.text = book.title
        bookView.titleLabel.text = book.title
        bookView.authorLabel.text = book.author
        bookView.pagesLabel.text = "\(book.pages)"
        bookView.releaseLabel.text = viewModel.formattedReleaseDate() ?? book.release_date
        
        let imageName = "harrypotter\(viewModel.currentIndex + 1)"
        bookView.bookImageView.image = UIImage(named: imageName)
        bookView.seriesNumberButton.setTitle("\(viewModel.currentIndex + 1)", for: .normal)
    }

    @objc private func seriesButtonTapped() {
        viewModel.showNextBook()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "데이터 로드 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    BookViewController()
}
