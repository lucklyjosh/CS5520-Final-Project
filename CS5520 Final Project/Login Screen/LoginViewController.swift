//
//  LoginViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/3/24.
//
import UIKit
import Firebase
import GoogleSignIn
class LoginViewController: UIViewController {
    
    override func loadView() {
        // Set the view to an instance of LoginScreen
        view = LoginScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loginScreen = view as? LoginScreen {
            loginScreen.onGoogleSignInButtonTapped = { [weak self] in
                print("Closure triggered")
                self?.handleGoogleSignIn()
            }
        }
    }



    func setupGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.style = .wide
        googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        if let loginScreen = view as? LoginScreen {
            loginScreen.addSubview(googleSignInButton)
            // Configure auto-layout or frame for googleSignInButton as needed
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
                // User is signed in to Firebase, navigate to the main screen
                self.navigateToMainScreen()
            }
        }
    }
    
    func navigateToMainScreen() {
        let mainScreenVC = MainScreenViewController()
        mainScreenVC.modalPresentationStyle = .fullScreen
        present(mainScreenVC, animated: true)
    }
}
