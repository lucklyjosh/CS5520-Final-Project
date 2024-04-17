//
//  Recipe.swift
//  CS5520 Final Project
//
//  Created by zining xie on 4/12/24.
//

//import Foundation
//import UIKit
//
////MARK: struct to create a package to send to the Display Screen...
//struct Recipe {
//        var name:String?
//        var ingredients:String?
//        var instructions:String?
//        var image: UIImage?
//    
//        
//        init(name: String, ingredients: String,instructions: String ,image: UIImage) {
//            self.name = name
//            self.ingredients = ingredients
//            self.instructions = ingredients
//            self.image = image
//        }
//    }

import Foundation
import UIKit

struct Recipe {
    var id: String
    var name: String
    var ingredients: String
    var instructions: String
    var imageUrl: String // URL to the image stored in Firebase Storage
    var likes: [String] // User IDs of users who have liked this recipe

    init(id: String = UUID().uuidString, name: String, ingredients: String, instructions: String, imageUrl: String, likes: [String] = []) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageUrl = imageUrl
        self.likes = likes
    }

    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "ingredients": ingredients,
            "instructions": instructions,
            "imageUrl": imageUrl,
            "likes": likes
        ]
    }
}

