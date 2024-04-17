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
//    var collectionView: UICollectionView!
//    var tableViewContacts: UITableView!
    
    private let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8"]
    
    private lazy var homeButton: UIButton = createBarButton(imageSystemName: "house")
    public lazy var profileButton: UIButton = createBarButton(imageSystemName: "person.crop.circle")
    public lazy var plusButton: UIButton = createPlusButton()
    
    
    
    
    public lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 15
        let totalPadding = padding * 3
        
        let availableWidth = UIScreen.main.bounds.width - totalPadding
        let sideLength = (availableWidth / 2) * 0.9

        layout.itemSize = CGSize(width: sideLength, height: sideLength)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        return layout
    }()
    
    public lazy var collectionViewInProfile: UICollectionView = {

        let collectionViewInProfile: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionViewInProfile.backgroundColor = .clear
        collectionViewInProfile.register(ContentCardCell.self, forCellWithReuseIdentifier: ContentCardCell.identifier)
        collectionViewInProfile.translatesAutoresizingMaskIntoConstraints = false
        return collectionViewInProfile
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupuserName()
        setupbuttonTakePhoto()
        setupprofileImageView()
        setupbuttonuserPosts()
        setupbuttonuserLikes()
        addSubview(bottomBar)
        addSubview(collectionViewInProfile)
        
        bottomBar.addSubview(homeButton)
        bottomBar.addSubview(profileButton)
        bottomBar.addSubview(plusButton)

        addBorderLineToView(bottomBar, atTop: true)
//<<<<<<< HEAD
//        collectionViewInProfile.dataSource = self
        collectionViewInProfile.reloadData()
//=======
////        collectionView.dataSource = self
//        collectionView.reloadData()
//>>>>>>> 5a1124def34c1eda19e6e848d3dc123bf4c6a7b0
        
        initConstraints()
    }
    
    private func addBorderLineToView(_ view: UIView, atTop: Bool) {
        let borderLine = UIView()
        borderLine.backgroundColor = .lightGray
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLine)

        NSLayoutConstraint.activate([
            borderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 2),
            atTop ? borderLine.topAnchor.constraint(equalTo: view.topAnchor) : borderLine.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createPlusButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func createBarButton(imageSystemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
            
            collectionViewInProfile.topAnchor.constraint(equalTo: userLikes.bottomAnchor, constant: 10),
            collectionViewInProfile.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionViewInProfile.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewInProfile.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -20),
            
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 70),
            
            homeButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 32),
            homeButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            profileButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -32),
            profileButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            plusButton.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -30),
            plusButton.widthAnchor.constraint(equalToConstant: 56),
            plusButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
   
    
    //MARK: unused functions...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

//extension ProfileView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
//            fatalError("Unable to dequeue ContentCardCell")
//        }
////        cell.configure(with: items[indexPath.item])
//        cell.configure(with: recipe)
//        return cell
//    }
//}
