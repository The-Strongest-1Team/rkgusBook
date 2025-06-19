import Foundation

final class BookViewModel {
    
    private let dataService: DataServiceProtocol
    private(set) var books: [Book] = []
    private(set) var currentIndex = 0 {
        didSet { onUpdate?() }
    }

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var currentBook: Book? {
        books.indices.contains(currentIndex) ? books[currentIndex] : nil
    }
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }

    func fetchBooks() {
        dataService.loadBooks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self?.books = books
                    self?.currentIndex = 0
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    func nextBook() {
        guard !books.isEmpty else { return }
        currentIndex = (currentIndex + 1) % books.count
    }

    func formattedDate() -> String? {
        guard let dateString = currentBook?.release_date else { return nil }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: dateString) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .none
        
        return outputFormatter.string(from: date)
    }
}
