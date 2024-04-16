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
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    var reciptsList = [Recipe]()
    
    
    override func loadView() {
        // Setting the ProfileView as the main view of ProfileViewController
        view = profileScreen
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                self.currentUser = nil
                self.profileScreen.userName.text = "John Doo"
//                self.profileScreen.floatingButtonChatIcon.isEnabled = false
//                self.profileScreen.floatingButtonChatIcon.isHidden = true
                
                //MARK: Reset tableView...
                self.reciptsList.removeAll()
                
                
                //MARK: Sign in bar button...
//                self.setupRightBarButton(isLoggedin: false)
                
            }else{
                //MARK: the user is signed in...
                self.currentUser = user
                self.profileScreen.userName.text = "\(user?.displayName ?? "Anonymous")"
//                self.profileScreen.floatingButtonChatIcon.isEnabled = true
//                self.profileScreen.floatingButtonChatIcon.isHidden = false
                
                //MARK: Logout bar button...
//                self.setupRightBarButton(isLoggedin: true)
                
                
//                if let username = user?.displayName{
//                    self.getUserEmail(byUsername:username) { email, error in
//                        if let error = error {
//                            print("Error: \(error.localizedDescription)")
//                        } else if let receiveremail = email {
//                            
//                            //MARK: Observe Firestore database to display the chat list...
//                            self.database.collection("users").document(receiveremail).collection("chats")
//                                .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
//                                    if let documents = querySnapshot?.documents{
//
//                                        
//                                        self.chatsList.removeAll()
//                                        for document in documents{
//                                            do{
//                                                let chat  = try document.data(as: Recipe.self)
//                                                self.chatsList.append(chat)
//                                            }catch{
//                                                print(error)
//                                            }
//                                        }
//                                        self.mainScreen.tableViewContacts.reloadData()
//                                    }
//                                })
//                            
//                        }
//                    }
//                    
//                }

            }
        }
    }
    
    //codes omitted...
    

    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    //codes omitted...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //codes omitted...
        profileScreen.profilePicture.menu = getMenuImagePicker()
        //codes omitted...
        self.profileScreen.collectionViewInProfile.reloadData()
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





