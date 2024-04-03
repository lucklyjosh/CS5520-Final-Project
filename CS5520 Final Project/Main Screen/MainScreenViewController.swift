//
//  MainScreenViewController.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/3/24.
//

import UIKit

class MainScreenViewController: UIViewController {

    let mainScreen = MainScreen()
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Foodie's Heaven"

    }
    
}
