//
//  ContentCardCell.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/2/24.
//

import UIKit

protocol ContentCardCellDelegate: AnyObject {
    func didTapCell(_ cell: ContentCardCell)
    func didTapLikeButton(on cell: ContentCardCell)
}

class ContentCardCell: UICollectionViewCell {
    static let identifier = "ContentCardCell"
    weak var delegate: ContentCardCellDelegate?
    
    
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap() {
        delegate?.didTapCell(self)
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
        delegate?.didTapLikeButton(on: self) 
    }
    
    func setLikeButtonState(_ isFavorited: Bool) {
        likeButton.isSelected = isFavorited
    }
    
    func configure(with recipe: Recipe) {
        titleLabel.text = recipe.name ?? "No Name"
        authorLabel.text = recipe.userName ?? "Anonymous"
        likeButton.isSelected = recipe.isFavorited
        
        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
            // Use an asynchronous method to download and set the image
            loadImage(from: url)
        } else {
            imageView.image = UIImage(named: "default")  // Use default image if URL is invalid
        }
    }

    func loadImage(from url: URL) {
        // This method should asynchronously load the image from the URL and set it to imageView
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }

}
