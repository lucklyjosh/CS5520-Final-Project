//
//  RecipeFirebaseManager.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/17/24.
//


import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore


extension AddRecipeScreenViewController{
    func uploadRecipePhotoToStorage(){
        var recipePhotoURL:URL?
        
        //MARK: Upload the profile photo if there is any...
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imagesRepo = storageRef.child("imagesRecipe")
                let imageRef = imagesRepo.child("\(NSUUID().uuidString).jpg")
                
                let uploadTask = imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                recipePhotoURL = url
                                self.saveTheRecipe(photoURL: recipePhotoURL)
                            }
                        })
                    }
                })
            }
        }else{
            saveTheRecipe(photoURL: recipePhotoURL)
        }
    }
    
    func saveTheRecipe(photoURL: URL?){
        guard let name = addRecipeScreen.recipeNameTextField.text,
              let ingredients = addRecipeScreen.ingredientsTextField.text,
              let instructions = addRecipeScreen.instructionsTextField.text,
              let currentUserId = Auth.auth().currentUser?.uid,
              let currentUser = Auth.auth().currentUser,
              let photoURL = photoURL
         else {
            print("Error: One or more fields are empty.")
            return
        }
        
        let userName = currentUser.displayName ?? "Unknown User"
        let database = Firestore.firestore()
        let recipeId = UUID().uuidString
        
        let documentReference = database.collection("recipes").document(recipeId)

        let newRecipe: [String: Any] = [
            "name": name,
            "ingredients": ingredients,
            "instructions": instructions,
            "currentUserId" : currentUserId,
            "userName":userName,
            "timestamp": Int64(Date().timeIntervalSince1970 * 1000),
            "photoURL": photoURL.absoluteString,
            "recipeId":recipeId
        ]
        
        documentReference.setData(newRecipe)
        { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(documentReference.documentID)")
                                self.updateUserPosts(with: documentReference.documentID, forUser: currentUserId)
            }
        }
    }

    func updateUserPosts(with recipeId: String, forUser userId: String) {
        let userRef = Firestore.firestore().collection("users").document(userId)
        userRef.updateData([
            "posts": FieldValue.arrayUnion([recipeId])
        ]) { error in
            if let error = error {
                print("Error updating user posts: \(error.localizedDescription)")
            } else {
                print("User posts updated with new recipe ID: \(recipeId)")
                NotificationCenter.default.post(name: Notification.Name("RecipeUpdated"), object: nil)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
    
