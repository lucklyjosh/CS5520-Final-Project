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
        print("in view did")
        super.viewDidLoad()
        self.title = "Foodie's Heaven"
        //MARK: on profileButton tap...
        mainScreen.profileButton.addTarget(self, action: #selector(onButtonProfileTapped), for: .touchUpInside)
        mainScreen.plusButton.addTarget(self, action: #selector(onButtonPlusTapped), for: .touchUpInside)
    }
    
    @objc func onButtonProfileTapped(){
        print("profile tapped")
        
        let profileScreen  = ProfileViewController()
        navigationController?.pushViewController(profileScreen, animated: true)
        
    }
    @objc func onButtonPlusTapped(){
        print("plus tapped+++++++++++++++++")
        
        let profileScreen  = ProfileViewController()
        navigationController?.pushViewController(profileScreen, animated: true)
        
    }
    
}
