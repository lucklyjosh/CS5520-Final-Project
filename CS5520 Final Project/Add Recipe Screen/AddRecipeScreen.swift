
//
//  AddRecipeScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/24/24.
//

import UIKit

class AddRecipeScreen: UIView {
    
    let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "default_recipe_image") // 设置默认图片
        return imageView
    }()
    
    let recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter recipe name"
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return textField
    }()
    
    let ingredientsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.text = "List ingredients"
        return textView
    }()
    
    let instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.text = "Add cooking steps"
        return textView
    }()
    
    let recipeTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add recipe type"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add →", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 0, blue: 127/255, alpha: 1)
        button.layer.cornerRadius = 20
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(recipeImageView)
        addSubview(recipeNameTextField)
        addSubview(ingredientsTextView)
        addSubview(instructionsTextView)
        addSubview(recipeTypeTextField)
        addSubview(addButton)
        
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        recipeTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            recipeNameTextField.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            recipeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            ingredientsTextView.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 16),
            ingredientsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ingredientsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            instructionsTextView.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 16),
            instructionsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            instructionsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            instructionsTextView.heightAnchor.constraint(equalToConstant: 100),
            
            recipeTypeTextField.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 16),
            recipeTypeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeTypeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeTypeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            addButton.topAnchor.constraint(equalTo: recipeTypeTextField.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}





