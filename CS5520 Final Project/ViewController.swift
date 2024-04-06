//
//  ViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 3/23/24.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
//        view = SignUpScreen()
//        view = LoginScreen()
//        view = MainScreen()
          view = ProfileView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Foodie's Heaven"
    }


}

