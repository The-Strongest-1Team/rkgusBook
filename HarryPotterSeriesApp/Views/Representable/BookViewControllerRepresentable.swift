//
//  BookViewControllerRepresentable.swift
//  HarryPotterSeriesApp
//
//  Created by 노가현 on 6/17/25.
//

import SwiftUI

struct BookViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BookViewController {
        return BookViewController()
    }

    func updateUIViewController(_ uiViewController: BookViewController, context: Context) {
    }
}
