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
                                print("url-----------")
                                print(url)
                                profileImageUrl = url
                                self.updateUserWithProfilePhotoURL(photoURL: profileImageUrl)
                            }
                        })
                    }
                })
            }
        }else{
//            registerUser(photoURL: profilePhotoURL)
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
//        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        
        print("\(photoURL)")
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured: \(String(describing: error))")
            }else{
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
    
//    func checkOrCreateChat(with receiverEmail: String, senderEmail: String, completion: @escaping (String?) -> Void) {
//        let db = Firestore.firestore()
//        let chatsCollection = db.collection("chats")
//
//        // Ensure user emails are in a consistent order
//        let usersArray = [receiverEmail, senderEmail].sorted()
//        
//        // Query to find existing chat between these users
//        chatsCollection.whereField("userEmails", isEqualTo: usersArray)
//            .getDocuments { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    completion(nil)
//                } else if let existingChat = querySnapshot?.documents.first {
//                    // Chat already exists
//                    let chatID = existingChat.documentID
//                    completion(chatID)
//                } else {
//                    // No chat exists, create a new one
//                    let newChatDocument = chatsCollection.document()
//                    newChatDocument.setData(["created_at": Timestamp(date: Date()), "userEmails": usersArray]) { error in
//                        if let error = error {
//                            print("Error creating chat: \(error)")
//                            completion(nil)
//                        } else {
//                            let chatID = newChatDocument.documentID
//                            completion(chatID)
//                        }
//                    }
//                }
//            }
//    }
//    
//    func getUserEmail(byUsername username: String, completion: @escaping (String?, Error?) -> Void) {
//        let db = Firestore.firestore()
//        db.collection("users").whereField("name", isEqualTo: username).getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//                completion(nil, err)
//            } else {
//                for document in querySnapshot!.documents {
//                    if let receiverEmail = document.data()["email"] as? String {
//                        completion(receiverEmail, nil)
//                        return
//                    }
//                }
//                // No matching user found
//                completion(nil, nil)
//            }
//        }
//    }
//
//    
//    func addMessageToChat(chatID: String, messageText: String, senderEmail: String) {
//        let db = Firestore.firestore()
//        let messageDocument = db.collection("chats").document(chatID).collection("messages").document()
//
//        let newMessageData: [String: Any] = [
//            "msgText": messageText,
//            "senderEmail": senderEmail,
//            "timestamp": Int64(Date().timeIntervalSince1970)
//        ]
//
//        messageDocument.setData(newMessageData) { error in
//            if let error = error {
//                print("Error sending message: \(error)")
//            } else {
//                print("Message sent successfully")
//            }
//        }
//        
//        self.scrollToBottom()
//        
//       
//    }
    
//    func updateLastMessage(chatID: String, messageText: String, receiverEmail: String, senderEmail: String) {
//        let db = Firestore.firestore()
//
//        // Define the chat reference for both sender and receiver
//        let senderChatRef = db.collection("users").document(senderEmail).collection("chats").document(chatID)
//        let receiverChatRef = db.collection("users").document(receiverEmail).collection("chats").document(chatID)
//
//        // Get the current timestamp
//        let currentTimestamp = Int64(Date().timeIntervalSince1970)
//
//        // Prepare the chat data
//        let chatData: [String: Any] = [
//            "lastMessage": messageText,
//            "latestTimeStamp": currentTimestamp,
//            "userEmails": [senderEmail, receiverEmail].sorted() // Sorted list of participant emails
//        ]
//
//        // Define a function to update or create a chat document
//        func createOrUpdateChat(chatRef: DocumentReference) {
//            chatRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    // Document exists, update it
//                    chatRef.updateData(chatData) { error in
//                        if let error = error {
//                            print("Error updating chat: \(error)")
//                        } else {
//                            print("Chat updated successfully.")
//                        }
//                    }
//                } else {
//                    // Document does not exist, create it
//                    chatRef.setData(chatData) { error in
//                        if let error = error {
//                            print("Error creating new chat: \(error)")
//                        } else {
//                            print("New chat created successfully.")
//                            self.chatScreen.messagesView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//
//        // Update or create chat for sender
//        createOrUpdateChat(chatRef: senderChatRef)
//
//        // Update or create chat for receiver
//        createOrUpdateChat(chatRef: receiverChatRef)
//        self.scrollToBottom()
//        
//    }

    
//    func getAllUserPosts(userId: String) {
//        let db = Firestore.firestore()
//        let postsRef = db.collection("users").document(userId).collection("posts")
//        postsRef.order(by: "timestamp").getDocuments { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//                // Consider updating UI or showing an alert here
//            } else if let documents = querySnapshot?.documents {
//                for document in documents {
//                    do {
//                        let firebaseResponse: [String: Any] = document.data()
//                        let postData: [String: Any] = [
//                            "msgText": firebaseResponse["name"]!,
//                            "senderEmail": firebaseResponse["senderEmail"]!,
//                            "timestamp": firebaseResponse["timestamp"]!
//                        ]
//
//                        // Create a Message instance using the Firebase response
//                        do {
//                            let message = try Message(dictionary: newMessageData)
//                            
//                            self.messages.append(message)
//                            self.messages.sort { $0.timestamp < $1.timestamp }
//                            
//                        } catch {
//                            print("Error initializing message: \(error)")
//                        }
//                    } catch {
//                        print("Error decoding message: \(error)")
//                    }
//                }
//                self.scrollToBottom()
//            }
//        }
//    }
    
}


