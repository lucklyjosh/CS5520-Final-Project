//
//  ProfileViewController.swift
//  CS5520 Final Project
//
//  Created by fei li on 4/3/24.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController{
    
    
    let profileScreen = ProfileView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    var reciptsList = [Recipe]()
    
    var recipes = [Recipe]()
    var likedRecipes = [Recipe]()
    
    let storage = Storage.storage()
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    
    
    override func loadView() {
        view = profileScreen
        profileScreen.collectionView.dataSource = self

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.showActivityIndicator()
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.profileScreen.userName.text = "John Doo"
                //MARK: Reset tableView...
                self.reciptsList.removeAll()
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.profileScreen.userName.text = "\(user?.displayName ?? "Anonymous")"
                
                if let currentUser = Auth.auth().currentUser {
                    let userID = currentUser.uid
                    print("Current user ID: \(userID)")
                } else {
                    // No user is currently logged in
                    print("No user is currently logged in.")
                }
                
                let db = Firestore.firestore()
                if let currentUser = Auth.auth().currentUser {
                    let userID = currentUser.uid
                    let docRef = db.collection("users").document(self.currentUser!.uid)
                
                self.fetchData(docRef: docRef) { profileImageUrl in
                    if let profileImageUrlString = profileImageUrl {
                        // Convert the string URL to a URL object
                        if let url = URL(string: profileImageUrlString) {
                            DispatchQueue.global().async {
                                if let imageData = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: imageData) {
                                        
                                        DispatchQueue.main.async {
                                            self.profileScreen.profileImageView.image = image
                                            
                                        }
                                    } else {
                                        print("Invalid image data")
                                    }
                                } else {
                                    print("Failed to load image data from URL")
                                }
                            }
                        } else {
                            print("Invalid profile image URL")
                            // Handle the case where the profile image URL string is invalid
                        }
                    } else {
                        print("Profile image URL not available")
                        // Handle the case where profile image URL is nil
                    }
                }
            }
            }
        }
    }
    
    //codes omitted...
    
    func fetchData(docRef: DocumentReference, completion: @escaping (String?) -> Void) {
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                let firebaseResponse = document.data()
                if let profileImageUrl = firebaseResponse?["profileImageUrl"] as? String {
                    print(profileImageUrl)
                    completion(profileImageUrl)
                } else {
                    print("Profile image URL not found")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileScreen.profilePicture.menu = getMenuImagePicker()
        profileScreen.userPosts.addTarget(self, action: #selector(onButtonUserPostsTapped), for: .touchUpInside)
        profileScreen.userLikes.addTarget(self, action: #selector(onButtonUserLikesTapped), for: .touchUpInside)
        
       
        profileScreen.collectionView.dataSource = self
        profileScreen.collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChange(notification:)), name: NSNotification.Name("FavoriteStatusChanged"), object: nil)
        onButtonUserPostsTapped()
       }
    
    @objc func handleFavoriteStatusChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let recipeId = userInfo["recipeId"] as? String,
              let newStatus = userInfo["newStatus"] as? Bool else { return }

        if let index = recipes.firstIndex(where: { $0.recipeId == recipeId }) {
            recipes[index].isFavorited = newStatus
            DispatchQueue.main.async {
                self.profileScreen.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    @objc func onButtonUserPostsTapped(){
        print("onButtonUserPostsTapped tapped")
        self.fetchUserRecipes()
    }
    @objc func onButtonUserLikesTapped(){
        print("onButtonUserLikesTapped tapped+++++++++++++++++")
        self.fetchUserLikes()

    }
    
    
    //MARK: menu for buttonTakePhoto setup...
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    //MARK: take Photo using Camera...
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    //MARK: pick Photo using Gallery...
    func pickPhotoFromGallery(){
        //MARK: Photo from Gallery...
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    func fetchUserRecipes() {
        print("fetching in profile")
        self.showActivityIndicator()
        let db = Firestore.firestore()
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let userDocRef = db.collection("users").document(userID)
            
            userDocRef.addSnapshotListener { [weak self] (documentSnapshot, error) in
                guard let self = self, let document = documentSnapshot?.data() else {
                    return
                }
                
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    if let posts = document["posts"] as? [String] {
                        
                        let favoritePosts = document["favoritePosts"] as? [String] ?? []
                        let userPosts = document["posts"] as? [String] ?? []
                        
                        var fetchedRecipes: [Recipe] = [] // Create an array to hold fetched recipes
                        
                        // Dispatch group to handle asynchronous calls
                        let dispatchGroup = DispatchGroup()
                        
                        for post in posts {
                            dispatchGroup.enter() // Enter the group before each call
                            self.getIndividualRecipeData(recipeId: post, favoritePosts: favoritePosts) { recipe in
                                if let recipe = recipe {
                                    fetchedRecipes.append(recipe)
                                }
                                dispatchGroup.leave() // Leave the group after each call
                            }
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            // All recipe data fetched, update UI
                            print("-----after fetching")
                            print(fetchedRecipes)
                            self.recipes = fetchedRecipes
                            self.profileScreen.collectionView.reloadData()
                            self.hideActivityIndicator()
                        }
                    } else {
                        self.recipes = [] // No recipes found
                    }
                }
            }
            
        }
        
    }

    func getIndividualRecipeData(recipeId: String, favoritePosts: [String], completion: @escaping (Recipe?) -> Void) {
        if recipeId.isEmpty {
            print("Received empty recipeId, aborting fetch.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("recipes").document(recipeId).getDocument { (document, error) in
            if let error = error {
                print("Error getting recipe document: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                var recipe = Recipe(
                    name: data?["name"] as? String ?? "",
                    userName: data?["userName"] as? String ?? "",
                    ingredients: data?["ingredients"] as? String ?? "",
                    instructions: data?["instructions"] as? String ?? "",
                    image: data?["photoURL"] as? String ?? "",
                    userId: data?["userId"] as? String ?? "",
                    timestamp: (data?["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                    recipeId: document.documentID
                )
                recipe.isFavorited = favoritePosts.contains(document.documentID)
                completion(recipe)
            } else {
                print("Recipe document does not exist")
                completion(nil)
            }
        }
    }

    
    func fetchUserLikes() {
        self.showActivityIndicator()
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(self.currentUser!.uid)

        userDocRef.getDocument { [weak self] (documentSnapshot, error) in
            guard let self = self, let document = documentSnapshot?.data() else {
                return
            }

            if let error = error {
                print("Error getting document: \(error)")
                return
            }

            if let posts = document["favoritePosts"] as? [String] {
                
                let favoritePosts = document["favoritePosts"] as? [String] ?? []
                let userPosts = document["posts"] as? [String] ?? []
                
                var fetchedRecipes: [Recipe] = []

                let dispatchGroup = DispatchGroup()

                for post in posts {
                    dispatchGroup.enter()
                    self.getIndividualRecipeData(recipeId: post, favoritePosts: favoritePosts) { recipe in
                        if var recipe = recipe {
                            recipe.isFavorited = true  // 确保设置为 true
                            fetchedRecipes.append(recipe)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.recipes = fetchedRecipes
                    self.profileScreen.collectionView.reloadData()
                    self.hideActivityIndicator()
                }
            } else {
                self.recipes = []
            }
        }
    }


    func fetchRecipes() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userId)
        userRef.getDocument { [weak self] (documentSnapshot, error) in
            guard let document = documentSnapshot, error == nil else {
                print("Error fetching user favorites: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let favoritePosts = document.data()?["favoritePosts"] as? [String] ?? []

            Firestore.firestore().collection("recipes").order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
                guard let self = self, let snapshot = snapshot, error == nil else {
                    print("Error getting documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.recipes = snapshot.documents.compactMap { document -> Recipe? in
                    var recipe = Recipe(
                        name: document.data()["name"] as? String ?? "",
                        userName: document.data()["userName"] as? String ?? "",
                        ingredients: document.data()["ingredients"] as? String ?? "",
                        instructions: document.data()["instructions"] as? String ?? "",
                        image: document.data()["photoURL"] as? String ?? "",
                        userId: document.data()["userId"] as? String ?? "",
                        timestamp: (document.data()["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        recipeId: document.documentID
                    )
                    recipe.isFavorited = favoritePosts.contains(document.documentID)
                    return recipe
                }
                self.profileScreen.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, ContentCardCellDelegate {
    
    func didTapLikeButton(on cell: ContentCardCell) {
        guard let indexPath = profileScreen.collectionView.indexPath(for: cell),
              let recipeId = recipes[indexPath.row].recipeId else {
            print("Error: Could not find index path or recipeId is nil")
            return
        }
        let isCurrentlyFavorited = recipes[indexPath.row].isFavorited

           print("Current button state before toggling: \(isCurrentlyFavorited)")

           toggleFavoriteStatus(for: recipeId, currentlyFavorited: isCurrentlyFavorited) { success in
               DispatchQueue.main.async {
                   if success {
                       let newFavoritedState = !isCurrentlyFavorited
                       cell.likeButton.isSelected = newFavoritedState
                       self.recipes[indexPath.row].isFavorited = newFavoritedState
                       print("Toggled button state to: \(newFavoritedState)")
                   } else {
                       // If the operation failed, revert the button state
                       cell.likeButton.isSelected = isCurrentlyFavorited
                       print("Failed to update the favorite status in Firestore.")
                   }
            }
        }
    }
    
    func toggleFavoriteStatus(for recipeId: String, currentlyFavorited: Bool, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            completion(false)
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userId)
        let updateAction = currentlyFavorited ? FieldValue.arrayRemove([recipeId]) : FieldValue.arrayUnion([recipeId])

        userRef.updateData(["favoritePosts": updateAction]) { error in
            if let error = error {
                print("Error updating favorite posts: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Favorite status successfully updated for recipeId: \(recipeId) to \(currentlyFavorited ? "not favorited" : "favorited")")
                if let index = self.recipes.firstIndex(where: { $0.recipeId == recipeId }) {
                    self.recipes[index].isFavorited = !currentlyFavorited
                }
                completion(true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
            fatalError("Unable to dequeue ContentCardCell")
        }
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        cell.likeButton.isSelected = recipe.isFavorited
        cell.delegate = self
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        navigateToDetail(for: recipe)
    }

    func didTapCell(_ cell: ContentCardCell) {
        guard let indexPath = profileScreen.collectionView.indexPath(for: cell) else { return }
        let recipe = recipes[indexPath.row]
        navigateToDetail(for: recipe)
    }

    func navigateToDetail(for recipe: Recipe) {
        let detailVC = RecipeScreenViewController()  
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}






