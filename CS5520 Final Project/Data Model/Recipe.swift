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
        var image: String?
        var userId: String?
        var timestamp:Date
        var recipeId:String?
        var isFavorited: Bool = false
        
    init(name: String, userName: String,ingredients: String,instructions: String ,image: String, userId: String, timestamp:Date ,recipeId:String ) {
            self.name = name
            self.userName = userName
            self.ingredients = ingredients
            self.instructions = instructions
            self.image = image
            self.userId = userId
            self.timestamp = timestamp
            self.recipeId = recipeId
        }
    }

