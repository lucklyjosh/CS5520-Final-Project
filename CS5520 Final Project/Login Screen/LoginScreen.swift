//
//  LoginScreen.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/23/24.
//
import UIKit
import GoogleSignIn
import GoogleSignInSwift

class LoginScreen: UIView {
    
    var onGoogleSignInButtonTapped: (() -> Void)?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Foodie's Heaven"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)

        // Create a new UIButton.Configuration
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1)  // Google's brand color
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.title = "Sign in with Google"
        config.titlePadding = 10
        config.imagePadding = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30) // Adjust content insets

        button.configuration = config

        // Add the Google logo image
        if let logoImage = UIImage(named: "Google") {
            button.setImage(logoImage, for: .normal)
        }

        return button
    }()
    
    let emailTextField: UITextField = createTextField(withPlaceholder: "example@gmail.com", iconName: "envelope")
    
    let passwordTextField: UITextField = createTextField(withPlaceholder: "Password", iconName: "lock")
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login ->", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 0, blue: 127/255, alpha: 1)
        button.layer.cornerRadius = 20
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up here!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    static func createTextField(withPlaceholder placeholder: String, iconName: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        textField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: iconName)
        textField.leftView?.addSubview(imageView)
        return textField
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubviews()
        setupAutoLayout()
        setupButtonTargets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .white
        addSubviews()
        setupAutoLayout()
        setupButtonTargets()
    }
    
    func setupButtonTargets() {
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
    }

    @objc func googleSignInButtonTapped() {
        print("Google Sign-In button tapped")
        onGoogleSignInButtonTapped?()
    }

    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signUpButton)
        addSubview(googleSignInButton)
    }
    
    func setupAutoLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, emailTextField, passwordTextField, googleSignInButton, loginButton, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])

        [emailTextField, passwordTextField, googleSignInButton, loginButton].forEach { view in
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    
}
