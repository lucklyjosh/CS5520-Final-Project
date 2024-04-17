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
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    let profileScreen = ProfileView()
    
    var handleAuth: AuthStateDidChangeListenerHandle?
    
    var currentUser:FirebaseAuth.User?
    
    let database = Firestore.firestore()
    
    var reciptsList = [Recipe]()
    
    let storage = Storage.storage()
    
//    var profileImageView: UIImageView!
    
    
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
                
                if let currentUser = Auth.auth().currentUser {
                    let userID = currentUser.uid
                    print("Current user ID: \(userID)")
                } else {
                    // No user is currently logged in
                    print("No user is currently logged in.")
                }

                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(self.currentUser!.uid)
                self.fetchData(docRef: docRef) { profileImageUrl in
                    if let profileImageUrlString = profileImageUrl {
                        // Convert the string URL to a URL object
                        if let url = URL(string: profileImageUrlString) {
                            DispatchQueue.global().async {
                                if let imageData = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: imageData) {
                                        
                                        DispatchQueue.main.async {
//                                            self.profileScreen.profilePicture.display(none)
//                                            profileImageView.image = image
                                        self.profileScreen.profileImageView.image = image
//
                                        }
                                    } else {
                                        print("Invalid image data")
                                    }
                                } else {
                                    print("Failed to load image data from URL")
                                }
                            }
                        } else {
                            print("Invalid profile image URL")
                            // Handle the case where the profile image URL string is invalid
                        }
                    } else {
                        print("Profile image URL not available")
                        // Handle the case where profile image URL is nil
                    }
                }




                

                
                

                
                
                
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
    
    func fetchData(docRef: DocumentReference, completion: @escaping (String?) -> Void) {
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                let firebaseResponse = document.data()
                if let profileImageUrl = firebaseResponse?["profileImageUrl"] as? String {
                    print(profileImageUrl)
                    completion(profileImageUrl)
                } else {
                    print("Profile image URL not found")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }

        
    

    
    //MARK: variable to store the picked Image...
    var pickedImage:UIImage?
    //codes omitted...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //codes omitted...
        profileScreen.profilePicture.menu = getMenuImagePicker()
        //codes omitted...
        self.profileScreen.collectionViewInProfile.reloadData()
//        profileScreen.userPosts.addTarget(self, action: #selector(onButtonUserPostsTapped), for: .touchUpInside)
    }
    
//fetch data from the fibase store and display
//    @objc func onButtonUserPostsTapped() {
//        let messageText = chatScreen.messageInputField.text ?? ""
//        if let senderEmail = Auth.auth().currentUser?.email, !messageText.isEmpty {
//            
//            getUserEmail(byUsername: chatPartnerName!) { email, error in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                } else if let receiveremail = email {
//                    print("receiver's email is: \(receiveremail)")
//                    
//                    self.checkOrCreateChat(with: receiveremail, senderEmail: senderEmail) { chatID in
//                               if let chatID = chatID {
//                                   self.addMessageToChat(chatID: chatID, messageText: messageText, senderEmail: senderEmail)
//                                   self.updateLastMessage(chatID: chatID, messageText: messageText, receiverEmail: receiveremail, senderEmail: senderEmail)
//                                   self.messages.removeAll()
//                                   self.chatScreen.messageInputField.text = ""
//                                   
//                               } else {
//                                   // Handle the case where chatID couldn't be created or retrieved
//                               }
//                           }
//                    
//                } else {
//                    print("No user found with that username")
//                }
//            }
//
//        } else {
//            // Handle the case where the message is empty or user email is not available
//        }
//    }
    
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

//extension UIImageView {
//    //MARK: Borrowed from: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
//    
//    func loadRemoteImage(from url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}






