import SwiftUI

struct BookViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BookViewController {
        return BookViewController()
    }

    func updateUIViewController(_ uiViewController: BookViewController, context: Context) {
    }
}
