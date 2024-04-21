//
//  UserPostsFirebaseManager.swift
//  CS5520 Final Project
//
//  Created by fei li on 4/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension ProfileViewController{
    
    func uploadProfilePhotoToStorage(){
        var profileImageUrl:URL?
        
        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesUsers")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profileImageUrl = url
                                self.updateUserWithProfilePhotoURL(photoURL: profileImageUrl)
                            }
                        })
                    }
                })
            }
        }else{
        }
    }
    
    func updateUserWithProfilePhotoURL(photoURL: URL?) {
        print("in update photo")
        guard let user = Auth.auth().currentUser else {
            print("No logged-in user")
            return
        }
        
        let userDocRef = Firestore.firestore().collection("users").document(user.uid)
        
        userDocRef.updateData(["profileImageUrl": photoURL?.absoluteString ?? ""]) { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
                return
            }
            self.setNameAndPhotoOfTheUserInFirebaseAuth(photoURL: photoURL)
            print("User document updated successfully with profile photo URL")
        }
    }
    
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured: \(String(describing: error))")
            }else{
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}


