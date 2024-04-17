//
//  SignUpViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/3/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {

    var signUpView: SignUpScreen!
    let childProgressView = ProgressSpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        signUpView.loginButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
   
    }
    
    override func loadView() {
        signUpView = SignUpScreen()
        view = signUpView
    }
    
    @objc func handleSignUp() {
        print("Sign Up button tapped")
        guard let username = signUpView.usernameTextField.text, !username.isEmpty,
              let email = signUpView.emailTextField.text, !email.isEmpty, isValidEmail(email: email),
              let password = signUpView.passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please fill in all fields correctly.")
            return
        }

        showActivityIndicator()  // Show the activity indicator while registering

        // Create a Firebase user with email and password
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            self.hideActivityIndicator()  // Hide the activity indicator regardless of the outcome

            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
                return
            }

            guard let uid = authResult?.user.uid else {
                print("Failed to retrieve UID")
                return
            }
            
            // Create User instance with the retrieved UID
            let newUser = User(uid: uid, username: username, email: email)
            
            // Save user details to Firestore
            self.saveUserDetailsToFirestore(user: newUser)
            
            // Optionally, update profile with username
            self.setNameOfTheUserInFirebaseAuth(name: username)
        }
    }

    func saveUserDetailsToFirestore(user: User) {
        let database = Firestore.firestore()
        database.collection("users").document(user.uid).setData(user.dictionary) { error in
            if let error = error {
                print("Error saving user to Firestore: \(error.localizedDescription)")
            } else {
                print("User registered and saved to Firestore successfully")
                self.closeScreen()
            }
        }
    }

    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func navigateToLogin() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("ShowLoginScreen"), object: nil)
        }
    }
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(
            title: "Error!", message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
    

    
    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            guard let self = self else { return }
            
            if error == nil {
                // Profile update successful
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            } else {
                // Error updating profile
                print("Error occurred: \(String(describing: error))")
            }
        }
    }
    
//    func saveUserDetailsToFirestore(user: [String: Any]) {
//        guard let email = user["email"] as? String else { return }
//        print("Saving user details to Firestore")
//        
//        let database = Firestore.firestore()
//        database.collection("users").document(email).setData(user) { [weak self] error in
//            guard let self = self else { return }
//            
//            if error == nil {
//                print("Saving user to Firestore succeeded!")
//                // Success handling...
//            } else {
//                // Error handling...
//                print("Error saving user to Firestore: \(String(describing: error))")
//            }
//        }
//    }
}
