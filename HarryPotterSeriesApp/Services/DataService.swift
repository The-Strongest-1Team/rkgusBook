import Foundation

protocol DataServiceProtocol {
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }

    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            return completion(.failure(DataError.fileNotFound))
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
            completion(.success(decoded.data.map { $0.attributes }))
        } catch {
            completion(.failure(DataError.parsingFailed))
        }
    }
}
