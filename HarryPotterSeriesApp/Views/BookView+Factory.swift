import UIKit

extension BookView {
    func createLabel(font: UIFont, textColor: UIColor, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .left, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.text = text
        return label
    }

    func createButton(titleColor: UIColor, backgroundColor: UIColor, font: UIFont, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }

    func createImageView(contentMode: UIView.ContentMode, cornerRadius: CGFloat, backgroundColor: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        imageView.backgroundColor = backgroundColor
        return imageView
    }

    func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        return stackView
    }
}
