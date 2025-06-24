import UIKit
import SnapKit

extension BookView {
    
    // 어떤 뷰가 어떤 뷰 안에 들어가는지
    func setupHierarchy() {
        // 1. 상단 고정 요소
        [headerTitleLabel, seriesButtonsStackView].forEach { addSubview($0) }
        
        // 2. ScrollView
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // 3.contentStackView에 콘텐츠 추가
        [mainStackView, dedicationStackView, summaryStackView, chaptersTitleLabel, chaptersStackView].forEach {
            contentStackView.addArrangedSubview($0)
        }

        // 4. 메인 스택
        mainStackView.addArrangedSubview(bookImageView)
        mainStackView.addArrangedSubview(textStackView)

        // 5. 타이틀, 상세 정보
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(authorStack)
        textStackView.addArrangedSubview(releaseStack)
        textStackView.addArrangedSubview(pagesStack)

        // 6. 정보 스택
        [authorTitleLabel, authorLabel].forEach { authorStack.addArrangedSubview($0) }
        [releaseTitleLabel, releaseLabel].forEach { releaseStack.addArrangedSubview($0) }
        [pagesTitleLabel, pagesLabel].forEach { pagesStack.addArrangedSubview($0) }

        // 7. 헌정사
        dedicationStackView.addArrangedSubview(dedicationTitleLabel)
        dedicationStackView.addArrangedSubview(dedicationLabel)

        // 8. 요약 구성
        summaryStackView.addArrangedSubview(summaryTitleLabel)
        summaryStackView.addArrangedSubview(summaryLabel)
        summaryStackView.addArrangedSubview(summaryButtonContainer)

        // 9. 챕터 제목/리스트 좌우 정렬
        chaptersTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        chaptersStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }

    // SnapKit 제약 설정
    func setupConstraints() {
        // 1. 헤더 타이틀
        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // 2. 시리즈 버튼 스택
        seriesButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        // 3. 스크롤 영역
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(seriesButtonsStackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        // 4. 컨텐츠 스택
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20) // scrollView 내부 여백
            make.width.equalTo(scrollView).offset(-40) // 양쪽 inset만큼 너비 보정
        }

        // 5. 책 이미지 크기 고정
        bookImageView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(150)
        }

        // 6. 헌정사/요약/챕터 스택 좌우 꽉 차게
        dedicationStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainStackView.snp.bottom).offset(24)
        }

        summaryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dedicationStackView.snp.bottom).offset(24)
        }

        // 7. 요약 버튼 컨테이너 높이 지정
        summaryButtonContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
    }

    // hugging, compression 우선순위 설정
    func configureContentPriorities() {
        // 텍스트보다 우선적으로 공간 확보
        bookImageView.setContentHuggingPriority(.required, for: .horizontal)
        bookImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
