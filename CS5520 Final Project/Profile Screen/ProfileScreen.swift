//
//  ProfileScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/24/24.
//

import UIKit

class ProfileView: UIView {
    var profilePicture: UIButton!
    var userName: UILabel!
    var userPosts: UIButton!
    var userLikes: UIButton!
    var profileImageView: UIImageView!
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 15
        let totalPadding = padding * 3
        
        let availableWidth = UIScreen.main.bounds.width - totalPadding
        let sideLength = (availableWidth / 2) * 0.9

        layout.itemSize = CGSize(width: sideLength, height: sideLength)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ContentCardCell.self, forCellWithReuseIdentifier: ContentCardCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupuserName()
        setupbuttonTakePhoto()
        setupprofileImageView()
        setupbuttonuserPosts()
        setupbuttonuserLikes()
        addSubview(collectionView)
        initConstraints()
    }
    func setupuserName(){
        userName = UILabel()
        userName.text = "Defualt User"
        userName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userName)
    }

    func setupbuttonTakePhoto(){
        profilePicture = UIButton(type: .system)
        profilePicture.setTitle("", for: .normal)
        profilePicture.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        profilePicture.contentHorizontalAlignment = .fill
        profilePicture.contentVerticalAlignment = .fill
        profilePicture.imageView?.contentMode = .scaleAspectFit
        profilePicture.showsMenuAsPrimaryAction = true
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.backgroundColor = .clear
        self.addSubview(profilePicture)
    }
    
    func setupprofileImageView(){
        profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "photo")
        profileImageView.contentMode = .scaleToFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImageView)
    }
    func setupbuttonuserPosts(){
        userPosts = UIButton(type: .system)
        userPosts.setTitle("My Posts", for: .normal)
        userPosts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userPosts)
    }
    func setupbuttonuserLikes(){
        userLikes = UIButton(type: .system)
        userLikes.setTitle("My Likes", for: .normal)
        userLikes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userLikes)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            
            profilePicture.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            profilePicture.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            
            userName.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 15),
            userName.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            userPosts.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userPosts.leadingAnchor.constraint(equalTo:leadingAnchor,constant:55),
            
            userLikes.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 16),
            userLikes.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-55),
            
            collectionView.topAnchor.constraint(equalTo: userLikes.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    
        ])
    }
    
    //MARK: unused functions...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


