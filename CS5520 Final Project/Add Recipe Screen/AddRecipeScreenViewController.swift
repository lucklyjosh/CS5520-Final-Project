//
//  AddRecipeScreenViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/10/24.
//

import UIKit
import PhotosUI

class AddRecipeScreenViewController: UIViewController{
    
//    
//    override func loadView() {
//        // Setting the ProfileView as the main view of ProfileViewController
//        view = AddRecipeScreen()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
    
    
 
    let addRecipeScreen = AddRecipeScreen()

    override func loadView() {
        // Setting the ProfileView as the main view of ProfileViewController
        view = addRecipeScreen
    }
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    //codes omitted...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //codes omitted...
        addRecipeScreen.picture.menu = getMenuImagePicker()
        //codes omitted...
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
}
