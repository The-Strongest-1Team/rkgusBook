import UIKit
import SnapKit

extension BookView {
    func setupHierarchy() {
        [headerTitleLabel, seriesNumberButton].forEach { addSubview($0) }
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        [mainStackView, dedicationStackView, summaryStackView, chaptersTitleLabel, chaptersStackView].forEach {
            contentStackView.addArrangedSubview($0)
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
        summaryStackView.addArrangedSubview(summaryButtonContainer)

        chaptersTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        chaptersStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    func setupConstraints() {
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        seriesNumberButton.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(seriesNumberButton.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentStackView.axis = .vertical
        contentStackView.spacing = 24

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
            make.width.equalTo(scrollView).offset(-40)
        }

        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
        }

        dedicationStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainStackView.snp.bottom).offset(24)
        }

        summaryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dedicationStackView.snp.bottom).offset(24)
        }

        summaryButtonContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }

    func configureContentPriorities() {
        bookImageView.setContentHuggingPriority(.required, for: .horizontal)
        bookImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
