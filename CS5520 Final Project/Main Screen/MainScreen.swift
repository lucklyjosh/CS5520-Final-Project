//
//  MainScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/24/24.
//

import UIKit

class MainScreen: UIView {
    
    private let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8"]

    private lazy var collectionView: UICollectionView = {
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

    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var menuButton: UIButton = createBarButton(imageSystemName: "line.horizontal.3")
    private lazy var searchButton: UIButton = createBarButton(imageSystemName: "magnifyingglass")
    private lazy var homeButton: UIButton = createBarButton(imageSystemName: "house")
    private lazy var profileButton: UIButton = createBarButton(imageSystemName: "person.crop.circle")
    private lazy var plusButton: UIButton = createPlusButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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
    
    private func createPlusButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func addBorderLine(to view: UIView) {
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
    
    private func addBorderLineToTopOfBottomBar() {
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
    private func setupViews() {
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(collectionView)

        topBar.addSubview(menuButton)
        topBar.addSubview(searchButton)
        
        bottomBar.addSubview(homeButton)
        bottomBar.addSubview(profileButton)
        bottomBar.addSubview(plusButton)

        addBorderLineToView(topBar, atTop: false)
        addBorderLineToView(bottomBar, atTop: true)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 10),
            
            menuButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            menuButton.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -8),
            menuButton.widthAnchor.constraint(equalToConstant: 24),
            menuButton.heightAnchor.constraint(equalToConstant: 24),
            
            searchButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            searchButton.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -8),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
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

// MARK: - UICollectionViewDataSource
extension MainScreen: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
            fatalError("Unable to dequeue ContentCardCell")
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}
