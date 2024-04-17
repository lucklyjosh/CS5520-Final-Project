//
//  ContentCardCell.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/2/24.
//

import UIKit

class ContentCardCell: UICollectionViewCell {
    static let identifier = "ContentCardCell"

    var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "default")
        if image == nil {
            print("Failed to load 'defaultImage'. Check if it's added to assets and named correctly.")
        }
        imageView.image = image
        return imageView
    }()


    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Default Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Default Author"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(likeButton)
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc func toggleLike() {
        likeButton.isSelected = !likeButton.isSelected
    }
    
    
    func configure(with title: String? = nil, author: String? = nil, image: UIImage? = nil) {
        titleLabel.text = title ?? "Default Title"
        authorLabel.text = author ?? "Default Author"
        imageView.image = image ?? UIImage(named: "default")  // Use default image if none is provided
    }

    
}
