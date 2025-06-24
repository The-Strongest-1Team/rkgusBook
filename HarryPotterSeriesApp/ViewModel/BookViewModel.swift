import Foundation

final class BookViewModel {
    private(set) var books: [Book] = [] // 파싱된 책 데이터 배열
    private(set) var currentIndex: Int = 0 // 선택된 책 인덱스

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    // 선택된 책 객체 반환
    var currentBook: Book? {
        guard books.indices.contains(currentIndex) else { return nil }
        return books[currentIndex]
    }

    // JSON 파일을 불러와 파싱
    func fetchBooks() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            onError?("data.json 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url) // 파일 → Data
            let decoded = try JSONDecoder().decode(BookResponse.self, from: data) // 디코딩
            books = decoded.data.map { $0.attributes } // 필요한 속성만 추출
            onUpdate?() // 뷰에 데이터 업데이트 알림
        } catch {
            onError?("데이터 파싱 오류: \(error.localizedDescription)")
        }
    }

    // 사용자가 시리즈 버튼을 눌렀을 때 호출, 인덱스 변경
    func setBook(at index: Int) {
        guard books.indices.contains(index) else { return } // 인덱스 유효성 검사
        currentIndex = index
        onUpdate?() // 책 정보 업데이트 트리거
    }

    func formattedDate() -> String? {
        guard let book = currentBook else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 원본 형식
        if let date = formatter.date(from: book.release_date) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return nil
    }
}
