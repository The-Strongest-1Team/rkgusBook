//
//  Book.swift
//  HarryPotterSeriesApp
//
//  Created by 노가현 on 6/15/25.
//

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

