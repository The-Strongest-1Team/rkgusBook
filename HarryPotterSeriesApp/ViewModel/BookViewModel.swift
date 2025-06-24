import Foundation

final class BookViewModel {
    private(set) var books: [Book] = []
    private(set) var currentIndex: Int = 0

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    var currentBook: Book? {
        guard books.indices.contains(currentIndex) else { return nil }
        return books[currentIndex]
    }

    func fetchBooks() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            onError?("data.json 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
            books = decoded.data.map { $0.attributes }
            onUpdate?()
        } catch {
            onError?("데이터 파싱 오류: \(error.localizedDescription)")
        }
    }

    func setBook(at index: Int) {
        guard books.indices.contains(index) else { return }
        currentIndex = index
        onUpdate?()
    }

    func formattedDate() -> String? {
        guard let book = currentBook else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: book.release_date) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return nil
    }
}
