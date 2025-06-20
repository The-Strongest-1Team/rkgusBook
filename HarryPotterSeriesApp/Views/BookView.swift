import UIKit

final class BookView: UIView {

    // MARK: - Header & Series
    lazy var headerTitleLabel = createLabel(font: .boldSystemFont(ofSize: 24), textColor: .black, numberOfLines: 0, textAlignment: .center)
    lazy var seriesNumberButton = createButton(titleColor: .white, backgroundColor: .systemBlue, font: .boldSystemFont(ofSize: 18), cornerRadius: 20)

    // MARK: - ScrollView & StackView
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    // MARK: - Book Info
    lazy var bookImageView = createImageView(contentMode: .scaleAspectFill, cornerRadius: 0, backgroundColor: .lightGray)
    lazy var titleLabel = createLabel(font: .boldSystemFont(ofSize: 20), textColor: .black, numberOfLines: 0)

    lazy var authorTitleLabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .black, text: "Author")
    lazy var authorLabel = createLabel(font: .systemFont(ofSize: 18), textColor: .darkGray)

    lazy var releaseTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Released")
    lazy var releaseLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    lazy var pagesTitleLabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .black, text: "Pages")
    lazy var pagesLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .gray)

    // MARK: - Dedication & Summary
    lazy var dedicationTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Dedication")
    lazy var dedicationLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)

    lazy var summaryTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Summary")
    lazy var summaryLabel = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)

    // MARK: - Chapters
    lazy var chaptersTitleLabel = createLabel(font: .boldSystemFont(ofSize: 18), textColor: .black, text: "Chapters")
    lazy var chaptersStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    // MARK: - Layout Stacks
    lazy var mainStackView = createStackView(axis: .horizontal, spacing: 20, alignment: .top)
    lazy var textStackView = createStackView(axis: .vertical, spacing: 12, alignment: .leading)

    lazy var authorStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var releaseStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)
    lazy var pagesStack = createStackView(axis: .horizontal, spacing: 8, alignment: .firstBaseline)

    lazy var dedicationStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)
   lazy var summaryStackView = createStackView(axis: .vertical, spacing: 8, alignment: .fill)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        configureContentPriorities()
        scrollView.showsVerticalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func updateChapters(_ chapters: [String]) {
        chaptersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for chapter in chapters {
            let label = createLabel(font: .systemFont(ofSize: 14), textColor: .darkGray, numberOfLines: 0)
            label.text = chapter
            chaptersStackView.addArrangedSubview(label)
        }
    }
}
