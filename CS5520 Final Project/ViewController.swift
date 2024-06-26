//
//  ViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/23/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ViewController: UIViewController {
    var mainScreen: MainScreen!
    var recipes = [Recipe]()
    let childProgressView = ProgressSpinnerViewController()
    var recipesListener: ListenerRegistration?
    
    override func loadView() {
        mainScreen = MainScreen()
        view = mainScreen
        mainScreen.collectionView.dataSource = self
       
    }
    
    override func viewDidLoad() {
        print("in view did")
        super.viewDidLoad()
        
        self.title = "Foodie's Heaven"
        //MARK: on profileButton tap...
        mainScreen.profileButton.addTarget(self, action: #selector(onButtonProfileTapped), for: .touchUpInside)
        mainScreen.plusButton.addTarget(self, action: #selector(onButtonPlusTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuthenticationState), name: NSNotification.Name("UserDidLogin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginScreen), name: NSNotification.Name("ShowLoginScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSignUpScreen), name: NSNotification.Name("ShowSignUpScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchRecipes), name: Notification.Name("RecipeUpdated"), object: nil)

        fetchRecipes()
        mainScreen.collectionView.dataSource = self
        mainScreen.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        updateAuthenticationState()
    }
    
    @objc func fetchRecipes() {
        self.showActivityIndicator()
        
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
                self.mainScreen.collectionView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }
    
    
    @objc func updateAuthenticationState() {
        print("Update called")
        if Auth.auth().currentUser != nil {
            print("User login")
            // User is logged in, show logout button
            let barIcon = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .plain, target: self, action: #selector(handleLogout))
            let barText = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            navigationItem.rightBarButtonItems = [barIcon, barText]
        } else {
            print("User not yet login")
            showLoginScreen()
        }
    }

    @objc func showLoginScreen() {
        let logInVC = LoginViewController()
        logInVC.modalPresentationStyle = .fullScreen
        present(logInVC, animated: true, completion: nil)
    }
    
    @objc func showSignUpScreen() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    
    
    @objc func handleLogout() {
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                self.updateAuthenticationState()
            } catch {
                print("Error logging out")
            }
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(logoutAlert, animated: true)
    }
    
    @objc func onButtonProfileTapped(){
        print("profile tapped in view controller----------------")
        let profileScreen  = ProfileViewController()
        navigationController?.pushViewController(profileScreen, animated: true)
        
    }
    @objc func onButtonPlusTapped(){
        print("plus tapped+++++++++++++++++")
        
        let AddRecipeScreen  = AddRecipeScreenViewController()
        navigationController?.pushViewController(AddRecipeScreen, animated: true)
        
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, ContentCardCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCardCell.identifier, for: indexPath) as? ContentCardCell else {
            fatalError("Unable to dequeue ContentCardCell")
        }
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        let isFavorited = recipe.isFavorited
        cell.setLikeButtonState(isFavorited)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        navigateToDetail(for: recipe)
    }

    func didTapCell(_ cell: ContentCardCell) {
        guard let indexPath = mainScreen.collectionView.indexPath(for: cell) else { return }
        let recipe = recipes[indexPath.row]
        navigateToDetail(for: recipe)
    }

    func navigateToDetail(for recipe: Recipe) {
        let detailVC = RecipeScreenViewController()  
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


