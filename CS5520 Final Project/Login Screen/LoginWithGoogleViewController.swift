//
//  LoginWithGoogleViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/11/24.
//

import UIKit
import Firebase
import GoogleSignIn

extension LoginViewController{

    func setupGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.style = .wide
        googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        if let loginScreen = view as? LoginScreen {
            loginScreen.addSubview(googleSignInButton)
        }
    }
    
    @objc func handleGoogleSignIn() {
        print("Handling Google Sign-In")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] signInResult, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                return
            }
            
            guard let user = signInResult?.user,
                  // Safely unwrapping the idToken
                  let idToken = user.idToken?.tokenString else {
                print("Google Sign-In error: Unable to extract ID token")
                return
            }
            // Accessing accessToken directly since it's non-optional
            let accessToken = user.accessToken.tokenString
            // Creating a Firebase credential with the extracted ID token and access token
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            // Using the Firebase credential to sign in to Firebase
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    print("Firebase Sign-In error: \(error.localizedDescription)")
                    return
                }
                if let authUser = authResult?.user {
                    self.updateFirestoreWithUserData(user: authUser)
                }
                // Navigate to the main screen
                self.closeScreen()
            }
            
        }
    }
    
    func updateFirestoreWithUserData(user: Firebase.User) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        let userData = [
            "uid": user.uid,
            "name": user.displayName ?? "",
            "email": user.email ?? "",
            "profileImageUrl": user.photoURL?.absoluteString ?? ""
        ]

        usersRef.document(user.uid).setData(userData, merge: true) { error in
            if let error = error {
                print("Error updating Firestore with user data: \(error.localizedDescription)")
            } else {
                print("User data successfully updated/added in Firestore")
            }
        }
    }
}
