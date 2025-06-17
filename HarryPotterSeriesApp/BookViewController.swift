import UIKit

class BookViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let volumeLabel = UILabel()
    private let dataService = DataService()
    
    private var books: [Book] = []
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadBooks()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        volumeLabel.font = UIFont.systemFont(ofSize: 18)
        volumeLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [volumeLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func loadBooks() {
        dataService.loadBooks { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let books):
                    if let firstBook = books.first {
                        self.titleLabel.text = firstBook.title
                        self.volumeLabel.text = ""
                    } else {
                        self.titleLabel.text = "데이터 없음"
                        self.volumeLabel.text = ""
                    }
                case .failure(let error):
                    self.titleLabel.text = "오류 발생"
                    self.volumeLabel.text = "\(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    BookViewController()
}
