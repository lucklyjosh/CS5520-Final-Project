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
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    var reciptsList = [Recipe]()
    
    var recipes = [Recipe]()
    
    let storage = Storage.storage()
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    
//    var profileImageView: UIImageView!
    
    
    override func loadView() {
        view = profileScreen
        profileScreen.collectionView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
//                                        self.fetchRecipes()
                                        self.fetchUserRecipes()
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
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(self.currentUser!.uid)
        
        userDocRef.addSnapshotListener { [weak self] (documentSnapshot, error) in
            guard let self = self, let document = documentSnapshot?.data() else {
                return
            }
            
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                if let posts = document["posts"] as? [String] {
                    var fetchedRecipes: [Recipe] = [] // Create an array to hold fetched recipes

                    // Dispatch group to handle asynchronous calls
                    let dispatchGroup = DispatchGroup()

                    for post in posts {
                        dispatchGroup.enter() // Enter the group before each call
                        self.getIndividualRecipeData(recipeId: post) { recipe in
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
                    }
                } else {
                    self.recipes = [] // No recipes found
                }
            }
        }
    }

    func getIndividualRecipeData(recipeId: String, completion: @escaping (Recipe?) -> Void) {
        let db = Firestore.firestore()
        db.collection("recipes").document(recipeId).getDocument { (document, error) in
            if let error = error {
                print("Error getting recipe document: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let userName = data?["userName"] as? String ?? ""
                let ingredients = data?["ingredients"] as? String ?? ""
                let instructions = data?["instructions"] as? String ?? ""
                let image = data?["photoURL"] as? String ?? ""
                let userId = data?["userId"] as? String ?? ""
                let timestamp = (data?["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                let recipe = Recipe(name: name, userName: userName, ingredients: ingredients, instructions: instructions, image: image, userId: userId, timestamp: timestamp)
                completion(recipe)
            } else {
                print("Recipe document does not exist")
                completion(nil)
            }
        }
    }

    
    func fetchRecipes() {
        print("fetching in profile")
        let db = Firestore.firestore()
        db.collection("recipes").order(by: "timestamp", descending: true).addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.recipes = snapshot?.documents.compactMap { document -> Recipe? in
                    let data = document.data()
                    let name = data["name"] as? String
                    let userName = data["userName"] as? String
                    let ingredients = data["ingredients"] as? String
                    let instructions = data["instructions"] as? String
                    let image = data["photoURL"] as? String
                    let userId = data["userId"] as? String
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    return Recipe(name: name ?? "", userName: userName ?? "", ingredients: ingredients ?? "", instructions: instructions ?? "", image: image ?? "", userId: userId ?? "", timestamp: timestamp)
                } ?? []
                print("_____-after fetching")
                print(self.recipes)
                self.profileScreen.collectionView.reloadData()
            }
        }
    }

    //codes omitted...
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, ContentCardCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
            fatalError("Unable to dequeue ContentCardCell")
        }
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
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
        let detailVC = RecipeScreenViewController()  // Ensure that this is the correct view controller class name.
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}






