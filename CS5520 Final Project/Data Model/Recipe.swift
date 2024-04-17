//
//  Recipe.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/12/24.
//
import Foundation
import UIKit

struct Recipe {
        var name:String?
        var userName: String?
        var ingredients:String?
        var instructions:String?
////<<<<<<< HEAD
////        var image: UIImage?
//    
//        
//        init(name: String, ingredients: String,instructions: String /*,image: UIImage*/) {
//            self.name = name
//            self.ingredients = ingredients
//            self.instructions = instructions
////            self.image = image
//        }
//=======
        var image: String?
        var userId: String?
        var timestamp:Date
    
    
        
    init(name: String, userName: String,ingredients: String,instructions: String ,image: String, userId: String, timestamp:Date  ) {
            self.name = name
            self.userName = userName
            self.ingredients = ingredients
            self.instructions = instructions
            self.image = image
            self.userId = userId
            self.timestamp = timestamp
            
        }
//>>>>>>> 5a1124def34c1eda19e6e848d3dc123bf4c6a7b0
    }

