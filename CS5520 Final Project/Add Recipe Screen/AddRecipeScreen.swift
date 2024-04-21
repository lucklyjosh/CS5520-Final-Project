
//
//  AddRecipeScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/24/24.
//

import UIKit

class AddRecipeScreen: UIView {
    
//    var picture: UIButton!
    
    let picture: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.showsMenuAsPrimaryAction = true
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let recipeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter recipe name"
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return textField
    }()
    
    let ingredientsTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.autocapitalizationType = .none
        textField.placeholder = "List ingredients"
        return textField
    }()
    
    let instructionsTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .gray
        textField.autocapitalizationType = .none 
        textField.placeholder = "Add cooking steps"
        return textField
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
        
        addSubview(picture)
        addSubview(recipeNameTextField)
        addSubview(ingredientsTextField)
        addSubview(instructionsTextField)
        
        picture.translatesAutoresizingMaskIntoConstraints = false
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextField.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picture.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            picture.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            picture.widthAnchor.constraint(equalToConstant: 100),
            picture.heightAnchor.constraint(equalToConstant: 100),
            
            recipeNameTextField.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 16),
            recipeNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            recipeNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            recipeNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            ingredientsTextField.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 16),
            ingredientsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ingredientsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ingredientsTextField.heightAnchor.constraint(equalToConstant: 100),
            
            instructionsTextField.topAnchor.constraint(equalTo: ingredientsTextField.bottomAnchor, constant: 16),
            instructionsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            instructionsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            instructionsTextField.heightAnchor.constraint(equalToConstant: 100),

        ])
    }
}





