//
//  Recipe.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/12/24.
//

import Foundation
import UIKit

//MARK: struct to create a package to send to the Display Screen...
struct Recipe {
        var name:String?
        var ingredients:String?
        var instructions:String?
//        var image: UIImage?
    
        
        init(name: String, ingredients: String,instructions: String /*,image: UIImage*/) {
            self.name = name
            self.ingredients = ingredients
            self.instructions = instructions
//            self.image = image
        }
    }

