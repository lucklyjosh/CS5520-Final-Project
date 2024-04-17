//
//  RecipeScreenViewController.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/11/24.
//


import UIKit

class RecipeScreenViewController: UIViewController {
    var recipe: Recipe?  // 存储配方数据

    var recipeScreen: RecipeScreen? {
        return self.view as? RecipeScreen
    }

    override func loadView() {
        self.view = RecipeScreen()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI() {
        guard let recipe = recipe else { return }
        
        // 设置文本字段的内容
        recipeScreen?.recipeNameTextField.text = recipe.name
        recipeScreen?.ingredientsTextView.text = recipe.ingredients
        recipeScreen?.instructionsTextView.text = recipe.instructions
        recipeScreen?.recipeTypeTextField.text = "Chinese Dishes"  // 示例，你可能需要一个实际字段

        // 从 URL 加载图片
        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
            loadRecipeImage(from: url)
        } else {
            // 设置默认图片
            recipeScreen?.recipeImageView.image = UIImage(named: "default_recipe_image")
        }
    }

    private func loadRecipeImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.recipeScreen?.recipeImageView.image = image
            }
        }.resume()
    }
}























//
//import UIKit
//import PhotosUI
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//
//class RecipeScreenViewController: UIViewController {
//    var recipe: Recipe?  // 用来存储传递到这个视图控制器的配方数据
//
//    override func loadView() {
//        let recipeScreen = RecipeScreen()
//        self.view = recipeScreen
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateUI()
//    }
//    
//    func updateUI() {
//        guard let recipeScreen = self.view as? RecipeScreen,
//              let recipe = recipe else { return }
//        
//        
//        let db = Firestore.firestore()
//        
//        let docRef = db.collection("users").document(self.currentUser!.uid)
//        self.fetchData(docRef: docRef) { profileImageUrl in
//            if let profileImageUrlString = profileImageUrl {
//                // Convert the string URL to a URL object
//                if let url = URL(string: profileImageUrlString) {
//                    DispatchQueue.global().async {
//                        if let imageData = try? Data(contentsOf: url) {
//                            if let image = UIImage(data: imageData) {
//                                
//                                DispatchQueue.main.async {
////                                            self.profileScreen.profilePicture.display(none)
////                                            profileImageView.image = image
//                                self.profileScreen.profileImageView.image = image
////
//                                }
//                            } else {
//                                print("Invalid image data")
//                            }
//                        } else {
//                            print("Failed to load image data from URL")
//                        }
//                    }
//                } else {
//                    print("Invalid profile image URL")
//                    // Handle the case where the profile image URL string is invalid
//                }
//            } else {
//                print("Profile image URL not available")
//                // Handle the case where profile image URL is nil
//            }
//        
//        
//        
//        
//        
//        
//        
//        
//        recipeScreen.recipeImageView.image = UIImage(named: recipe.imageName) // 假设 Recipe 对象有 imageName 属性
//        recipeScreen.recipeNameTextField.text = recipe.name
//        recipeScreen.ingredientsTextView.text = recipe.ingredients
//        recipeScreen.instructionsTextView.text = recipe.instructions
//    }
//}
