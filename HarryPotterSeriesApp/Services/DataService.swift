//
//  DataService.swift
//  HarryPotterSeriesApp
//
//  Created by 노가현 on 6/15/25.
//

import Foundation

class DataService {
    
    enum DataError: Error {
        case fileNotFound
        case parsingFailed
    }
    
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
            let books = bookResponse.data.map { $0.attributes }
            completion(.success(books))
        } catch {
            print("🚨 J SON 파싱 에러 : \(error)")
            completion(.failure(DataError.parsingFailed))
        }
    }
}
