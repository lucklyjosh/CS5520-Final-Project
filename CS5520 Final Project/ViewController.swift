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

//    override func loadView() {
//        view = SignUpScreen()
//        view = LoginScreen()
//        view = MainScreen()
//          view = ProfileView()
//            view = RecipeScreen()
//            view = AddRecipeScreen()
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Foodie's Heaven"
//    }


    var mainScreen: MainScreen!
    var recipes = [Recipe]()
    
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
        fetchRecipes()
        print("---")
        print(self.recipes)
        mainScreen.collectionView.dataSource = self
//        mainScreen.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAuthenticationState()
    }
    
//    func 
//    delegateOnAddRecipe(recipe:Recipe){
//        recipes.append(recipe)
//        print(recipes)
//        mainScreen.tableViewContacts.reloadData()
//    }
    
    func fetchRecipes() {
        let db = Firestore.firestore()
        db.collection("recipes").order(by: "timestamp", descending: true).getDocuments { [weak self] (snapshot, error) in
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
                    let recipeId = data["recipeId"] as? String
                    
                    return Recipe(name: name ?? "", userName: userName ?? "", ingredients: ingredients ?? "", instructions: instructions ?? "", image: image ?? "", userId: userId ?? "", timestamp: timestamp, recipeId: recipeId ?? "")
                } ?? []
                self.mainScreen.collectionView.reloadData()
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
        print("profile tapped")
        
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
        let detailVC = RecipeScreenViewController()  // Ensure that this is the correct view controller class name.
        detailVC.recipe = recipe
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


