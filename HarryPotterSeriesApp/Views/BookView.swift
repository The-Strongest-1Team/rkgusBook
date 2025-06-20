import UIKit
import SnapKit //

final class BookView: UIView {
    
    lazy var headerTitleLabel = createLabel(font: .boldSystemFont(ofSize: 24), textColor: .black, numberOfLines: 0, textAlignment: .center)
    
    lazy var seriesNumberButton = createButton(titleColor: .white, backgroundColor: .systemBlue, font: .boldSystemFont(ofSize: 18), cornerRadius: 20)
    
    lazy var bookImageView = createImageView(contentMode: .scaleAspectFill, cornerRadius: 8, backgroundColor: .lightGray)
    
    lazy var titleLabel = createLabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0)
    
    private lazy var authorTitleLabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .black, text: "Author")
    lazy var authorLabel = createLabel(font: .systemFont(ofSize: 18), textColor: .darkGray)
        
    private lazy var releaseTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Released")
    lazy var releaseLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)
    
    private lazy var pagesTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Pages")
    lazy var pagesLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)
    
    lazy var dedicationTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Dedication")
    lazy var dedicationLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
    
    lazy var summaryTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Summary")
    lazy var summaryLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
    
    private lazy var mainStackView = createStackView(axis: .horizontal, spacing: 20, alignment: .top)
    private lazy var textStackView = createStackView(axis: .vertical, spacing: 12, alignment: .leading)
    
    private lazy var authorStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    private lazy var releaseStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    private lazy var pagesStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    
    private lazy var dedicationStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)
    private lazy var summaryStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) 구현되지 않음")
    }
    
    private func setupUI() {
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        configureContentPriorities()
    }
    
    private func setupHierarchy() {
        [headerTitleLabel, seriesNumberButton, mainStackView, dedicationStackView, summaryStackView].forEach {
            addSubview($0)
        }

        mainStackView.addArrangedSubview(bookImageView)
        mainStackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(authorStack)
        textStackView.addArrangedSubview(releaseStack)
        textStackView.addArrangedSubview(pagesStack)

        [authorTitleLabel, authorLabel].forEach { authorStack.addArrangedSubview($0) }
        [releaseTitleLabel, releaseLabel].forEach { releaseStack.addArrangedSubview($0) }
        [pagesTitleLabel, pagesLabel].forEach { pagesStack.addArrangedSubview($0) }

        dedicationStackView.addArrangedSubview(dedicationTitleLabel)
        dedicationStackView.addArrangedSubview(dedicationLabel)

        summaryStackView.addArrangedSubview(summaryTitleLabel)
        summaryStackView.addArrangedSubview(summaryLabel)
    }
    
    private func setupConstraints() {
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        seriesNumberButton.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(seriesNumberButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dedicationStackView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        summaryStackView.snp.makeConstraints { make in
            make.top.equalTo(dedicationStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func configureContentPriorities() {
        bookImageView.setContentHuggingPriority(.required, for: .horizontal)
        bookImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}

private extension BookView {
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
        imageView.layer.cornerRadius = cornerRadius
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
