//
//  AddRecipeScreenViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/10/24.
//

import UIKit
import PhotosUI
import FirebaseStorage

class AddRecipeScreenViewController: UIViewController{

    let addRecipeScreen = AddRecipeScreen()
    let storage = Storage.storage()
    let childProgressView = ProgressSpinnerViewController()
    
    //MARK: delegate to ViewController when getting back...
    var delegate:ViewController!
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    
    override func loadView() {
        // Setting the ProfileView as the main view of ProfileViewController
        view = addRecipeScreen
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRecipeScreen.picture.menu = getMenuImagePicker()
        //MARK: setting the add button to the navigation controller...
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(onSaveButtonTapped)
        )
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
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(
            title: "Error!", message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    //MARK: submit button tapped action...
    @objc func onSaveButtonTapped(){
        self.showActivityIndicator()
        
        // Check if email is valid
        if let name = addRecipeScreen.recipeNameTextField.text,!name.isEmpty {
        } else {
            showErrorAlert(message: "Nmae field cannot be empty.")
        }
        // Check if userName is valid
        if let ingredients = addRecipeScreen.ingredientsTextField.text,!ingredients.isEmpty {
            
        } else {
            // Handle case where email field is empty
            showErrorAlert(message: "ingredients field cannot be empty.")
        }
        // Check if email is valid
        if let instructions = addRecipeScreen.instructionsTextField.text,!instructions.isEmpty {
            
        } else {
            // Handle case where email field is empty
            showErrorAlert(message: "instruciotns field cannot be empty.")
        }
            //MARK: creating a new user on Firebase with photo...
//            showActivityIndicator()
            uploadRecipePhotoToStorage()
    }
}
        
