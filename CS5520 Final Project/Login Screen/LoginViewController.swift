//
//  LoginViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/3/24.
//
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var loginView: LoginScreen!
    
    override func loadView() {
        loginView = LoginScreen()
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loginScreen = view as? LoginScreen {
            loginScreen.onGoogleSignInButtonTapped = { [weak self] in
                print("Closure triggered")
                self?.handleGoogleSignIn()
            }
        }
        loginView.signUpButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
  
    }

    @objc func navigateToSignUp() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("ShowSignUpScreen"), object: nil)
        }
    }
    
    @objc func handleLogin() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please fill in both email and password.")
            return
        }
        signInToFirebase(email: email, password: password)
    }
    
    func showErrorAlert(message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func signInToFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }

            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                // Successful login
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogin"), object: nil)

                self.closeScreen()
            }
        }
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }

}
