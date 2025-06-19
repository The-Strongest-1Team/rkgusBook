//
//  BookView.swift
//  HarryPotterSeriesApp
//
//  Created by 노가현 on 6/18/25.
//

import UIKit

final class BookView: UIView {
    
    let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seriesNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let authorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Author"
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    let releaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Released"
        return label
    }()
    
    let releaseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let pagesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.text = "Pages"
        return label
    }()
    
    let pagesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        addSubview(headerTitleLabel)
        addSubview(seriesNumberButton)
        
        NSLayoutConstraint.activate([
            headerTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            seriesNumberButton.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 10),
            seriesNumberButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            seriesNumberButton.widthAnchor.constraint(equalToConstant: 40),
            seriesNumberButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20
        mainStackView.alignment = .top
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(bookImageView)
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = 12
        textStackView.alignment = .leading
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        
        let authorStack = UIStackView()
        authorStack.axis = .horizontal
        authorStack.spacing = 8
        authorStack.alignment = .firstBaseline
        authorStack.addArrangedSubview(authorTitleLabel)
        authorStack.addArrangedSubview(authorLabel)
        textStackView.addArrangedSubview(authorStack)
        
        let releaseStack = UIStackView()
        releaseStack.axis = .horizontal
        releaseStack.spacing = 8
        releaseStack.alignment = .firstBaseline
        releaseStack.addArrangedSubview(releaseTitleLabel)
        releaseStack.addArrangedSubview(releaseLabel)
        textStackView.addArrangedSubview(releaseStack)
        
        let pagesStack = UIStackView()
        pagesStack.axis = .horizontal
        pagesStack.spacing = 8
        pagesStack.alignment = .firstBaseline
        pagesStack.addArrangedSubview(pagesTitleLabel)
        pagesStack.addArrangedSubview(pagesLabel)
        textStackView.addArrangedSubview(pagesStack)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: seriesNumberButton.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        bookImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        bookImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
