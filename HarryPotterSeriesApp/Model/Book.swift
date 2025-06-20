import Foundation

struct BookResponse: Codable {
    let data: [BookData]
}

struct BookData: Codable {
    let attributes: Book
}

struct Book: Codable {
    let title: String
    let author: String
    let pages: Int
    let release_date: String
    let dedication: String
    let summary: String
    let wiki: String?
}

