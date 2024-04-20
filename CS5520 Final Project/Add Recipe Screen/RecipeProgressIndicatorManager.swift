//
//  RecipeProgressIndicatorManager.swift
//  CS5520 Final Project
//
//  Created by fei li on 4/20/24.
//

import Foundation

extension AddRecipeScreenViewController:ProgressSpinnerDelegate{
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
}
