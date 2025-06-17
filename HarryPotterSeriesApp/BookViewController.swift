import UIKit

class BookViewController: UIViewController {
    
    // UI Components
    
    private let titleLabel = UILabel()
    private let volumeButton = UIButton(type: .system)
    
    // Properties
    
    private let dataService = DataService()
    private var books: [Book] = []
    private var currentIndex = 0
    
    // ifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchBooks()
    }
}

// UI Configuration

private extension BookViewController {
    
    func configureUI() {
        view.backgroundColor = .white
        setupTitleLabel()
        setupVolumeButton()
        setupConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func setupVolumeButton() {
        volumeButton.setTitle("1", for: .normal)
        volumeButton.setTitleColor(.white, for: .normal)
        volumeButton.titleLabel?.font = .systemFont(ofSize: 16)
        volumeButton.backgroundColor = .systemBlue
        volumeButton.layer.cornerRadius = 25
        volumeButton.layer.masksToBounds = true
        volumeButton.translatesAutoresizingMaskIntoConstraints = false
        volumeButton.addTarget(self, action: #selector(didTapVolumeButton), for: .touchUpInside)
        view.addSubview(volumeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            volumeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            volumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            volumeButton.widthAnchor.constraint(equalToConstant: 50),
            volumeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// Data Loading

private extension BookViewController {
    
    func fetchBooks() {
        dataService.loadBooks { [weak self] result in
            DispatchQueue.main.async {
                self?.handleBookResult(result)
            }
        }
    }
    
    func handleBookResult(_ result: Result<[Book], Error>) {
        switch result {
        case .success(let loadedBooks):
            books = loadedBooks
            updateUI(for: currentIndex)
        case .failure:
            titleLabel.text = "오류 발생"
            volumeButton.setTitle("-", for: .normal)
        }
    }
}

// UI Update

private extension BookViewController {
    
    func updateUI(for index: Int) {
        guard books.indices.contains(index) else { return }
        let book = books[index]
        titleLabel.text = book.title
        volumeButton.setTitle("\(index + 1)", for: .normal)
    }
    
    @objc func didTapVolumeButton() {
        guard !books.isEmpty else { return }
        currentIndex = (currentIndex + 1) % books.count
        updateUI(for: currentIndex)
    }
}

#Preview {
    BookViewController()
}
