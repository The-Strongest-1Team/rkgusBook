import Foundation

final class BookViewModel {
    
    private let dataService: DataService
    private(set) var books: [Book] = []
    private(set) var currentIndex: Int = 0 {
        didSet {
            self.bindBookToView?()
        }
    }
    
    var bindBookToView: (() -> Void)?
    var bindError: ((String) -> Void)?
    
    var currentBook: Book? {
        guard books.indices.contains(currentIndex) else { return nil }
        return books[currentIndex]
    }
    
    init(dataService: DataService = DataService()) {
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
                    self?.bindError?(error.localizedDescription)
                }
            }
        }
    }
    
    func showNextBook() {
        guard !books.isEmpty else { return }
        currentIndex = (currentIndex + 1) % books.count
    }
    
    func formattedReleaseDate() -> String? {
        guard let dateString = currentBook?.release_date else { return nil }
        return DateFormatter.bookReleaseDateFormatter.string(from: dateString)
    }
}

private extension DateFormatter {
    static let bookReleaseDateFormatter: DateFormatter = {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"
        
        return DateFormatter.createFormatter(input: inputFormatter, output: outputFormatter)
    }()
    
    static func createFormatter(input: DateFormatter, output: DateFormatter) -> DateFormatter {
        output.locale = Locale(identifier: "en_US_POSIX")
        return output
    }
    
    func string(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        return self.string(from: date)
    }
}
