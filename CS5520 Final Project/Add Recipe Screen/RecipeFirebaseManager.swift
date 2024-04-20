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
        // 从视图中获取配方的各个部分
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
        
        
        // 获取对 Firestore 数据库的引用
        let database = Firestore.firestore()
        
        // 创建新的文档引用并添加数据
        
        let recipeId = UUID().uuidString
        
        let documentReference = database.collection("recipes").document(recipeId)
        
        
        
        // 使用 setData 来向 Firestore 添加数据
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
                // 处理错误情况
                print("Error adding document: \(error.localizedDescription)")
            } else {
                // 打印文档的ID，确认添加成功
                print("Document added with ID: \(documentReference.documentID)")
                self.hideActivityIndicator()
                                self.updateUserPosts(with: documentReference.documentID, forUser: currentUserId)
                // 异步返回上一个视图控制器
//                DispatchQueue.main.async {
//                    self.navigationController?.popViewController(animated: true)
//                }
            }
        }
    }

    /// 更新用户的 posts 数组，添加新的配方 ID
    func updateUserPosts(with recipeId: String, forUser userId: String) {
        let userRef = Firestore.firestore().collection("users").document(userId)
        // 使用 FieldValue.arrayUnion 来添加新元素，避免重复
        userRef.updateData([
            "posts": FieldValue.arrayUnion([recipeId])
        ]) { error in
            if let error = error {
                print("Error updating user posts: \(error.localizedDescription)")
            } else {
                print("User posts updated with new recipe ID: \(recipeId)")
                DispatchQueue.main.async {
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
}
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//
//
//
//
//
//
//
//                if let name = addRecipeScreen.recipeNameTextField.text,
//                   let ingredients = addRecipeScreen.ingredientsTextField.text,
//                   let instructions = addRecipeScreen.instructionsTextField.text{
//                   let currentUser = Auth.auth().currentUser?.uid
//    }
//        let database = Firestore.firestore()
//
//        // 创建新的文档引用并添加数据
//        let documentReference = database.collection("recipes").document()
//
//        // 使用 setData 来向 Firestore 添加数据
//        documentReference.setData([
//            "name": name,
//            "ingredients": ingredients,
//            "instructions": instructions,
//
//        ]) { error in
//            if let error = error {
//                // 处理错误情况
//                print("Error adding document: \(error.localizedDescription)")
//            } else {
//                // 打印文档的ID，确认添加成功
//                print("Document added with ID: \(documentReference.documentID)")
//            }
//        }
//    }
//}
//
//}
//
//

    
//    func registerUser(photoURL: URL?){
//        if let name = addRecipeScreen.recipeNameTextField.text,
//           let ingredients = addRecipeScreen.ingredientsTextField.text,
//           let instructions = addRecipeScreen.instructionsTextField.text{
//            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
//                if error == nil{
//                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
//                }
//            })
//        }
//    }
//
//    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = name
//        changeRequest?.photoURL = photoURL
//
//        print("\(photoURL)")
//        changeRequest?.commitChanges(completion: {(error) in
//            if error != nil{
//                print("Error occured: \(String(describing: error))")
//            }else{
//                self.navigationController?.popViewController(animated: true)
//            }
//        })
//    }
//}


//
//
//class RecipeFirebaseManager: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
