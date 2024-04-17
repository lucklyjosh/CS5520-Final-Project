////
////  ContentCardCellViewController.swift
////  CS5520 Final Project
////
////  Created by Josh wen on 4/17/24.
////
//
//import UIKit
//import FirebaseFirestore
//import FirebaseAuth
//
//class ContentCardCellViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ContentCardCellDelegate {
//    
//    var collectionView: UICollectionView!
//    var recipes: [Recipe] = [] // Your recipes data source
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCollectionView()
//    }
//
//    func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(ContentCardCell.self, forCellWithReuseIdentifier: ContentCardCell.identifier)
//        view.addSubview(collectionView)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return recipes.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
//            fatalError("Unable to dequeue ContentCardCell")
//        }
//        let recipe = recipes[indexPath.row]
//        cell.configure(with: recipe)
//        cell.delegate = self
//        return cell
//    }
//
//    // MARK: ContentCardCellDelegate
//    func didTapLikeButton(on cell: ContentCardCell) {
//        guard let indexPath = collectionView.indexPath(for: cell),
//              let userId = Auth.auth().currentUser?.uid else { return }
//
//        let recipe = recipes[indexPath.row]
//        let isLiked = recipe.likes.contains(userId)
//        updateLikeStatusInFirestore(recipeId: recipe.id, isLiked: !isLiked, userId: userId)
//    }
//
//    func updateLikeStatusInFirestore(recipeId: String, isLiked: Bool, userId: String) {
//        let database = Firestore.firestore()
//        let recipeRef = database.collection("recipes").document(recipeId)
//
//        if isLiked {
//            // Adding a like
//            print("Attempting to add a like from user: \(userId) to recipe: \(recipeId)")
//            recipeRef.updateData([
//                "likes": FieldValue.arrayUnion([userId])
//            ]) { error in
//                if let error = error {
//                    print("Failed to add like to the recipe: \(error.localizedDescription)")
//                } else {
//                    print("Like successfully added to the database for recipe: \(recipeId) by user: \(userId).")
//                }
//            }
//        } else {
//            // Removing a like
//            print("Attempting to remove a like from user: \(userId) from recipe: \(recipeId)")
//            recipeRef.updateData([
//                "likes": FieldValue.arrayRemove([userId])
//            ]) { error in
//                if let error = error {
//                    print("Failed to remove like from the recipe: \(error.localizedDescription)")
//                } else {
//                    print("Like successfully removed from the database for recipe: \(recipeId) by user: \(userId).")
//                }
//            }
//        }
//    }
//
//}
