//
//  RecipeScreenViewController.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/11/24.
//


import UIKit

class RecipeScreenViewController: UIViewController {
    var recipe: Recipe?

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
        recipeScreen?.recipeNameTextField.text = recipe.name
        recipeScreen?.ingredientsTextView.text = recipe.ingredients
        recipeScreen?.instructionsTextView.text = recipe.instructions
        recipeScreen?.recipeTypeTextField.text = "Chinese Dishes"
        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
            loadRecipeImage(from: url)
        } else {
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















