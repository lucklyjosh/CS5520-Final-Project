//
//  ProfileViewController.swift
//  CS5520 Final Project
//
//  Created by fei li on 4/3/24.
//



//class ProfileViewController: UIViewController {
//    
//    override func loadView() {
//        // Setting the ProfileView as the main view of ProfileViewController
//        view = ProfileView()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//    
//
//
//}

//
//  RegisterViewController.swift
//  App12
//
//  Created by Sakib Miazi on 6/2/23.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    
    //codes omitted...
    
    override func loadView() {
        // Setting the ProfileView as the main view of ProfileViewController
        view = profileScreen
    }
    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    //codes omitted...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //codes omitted...
        profileScreen.profilePicture.menu = getMenuImagePicker()
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
    //codes omitted...
}





