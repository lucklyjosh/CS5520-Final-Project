//
//  MainScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/24/24.
//

import UIKit

class MainScreen: UIView {
    
    var buttonPF: UIButton!
    var homeButton: UIButton!
    var profileButton: UIButton!
    var plusButton: UIButton!
    
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8"]

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

    var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        homeButton = createBarButton(imageSystemName: "house")
        profileButton = createBarButton(imageSystemName: "person.crop.circle")
        plusButton = createPlusButton()

        setupViews()
        setupLayout()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBarButton(imageSystemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createPlusButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func addBorderLine(to view: UIView) {
        let borderLine = UIView()
        borderLine.backgroundColor = .lightGray
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderLine)

        NSLayoutConstraint.activate([
            borderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func addBorderLineToTopOfBottomBar() {
        let borderLine = UIView()
        borderLine.backgroundColor = .lightGray
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(borderLine)

        NSLayoutConstraint.activate([
            borderLine.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            borderLine.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            borderLine.topAnchor.constraint(equalTo: bottomBar.topAnchor),
            borderLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func addBorderLineToView(_ view: UIView, atTop: Bool) {
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
    func setupViews() {
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(collectionView)
        
        bottomBar.addSubview(homeButton)
        bottomBar.addSubview(profileButton)
        bottomBar.addSubview(plusButton)

        addBorderLineToView(topBar, atTop: false)
        addBorderLineToView(bottomBar, atTop: true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 10),
              
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor, constant: -20),
            
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
}

