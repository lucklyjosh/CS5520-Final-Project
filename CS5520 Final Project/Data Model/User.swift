//
//  User.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/16/24.
//

import Foundation

struct User {
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var favoritePosts: [String]
    var posts: [String]

    init(uid: String, username: String, email: String, profileImageUrl: String = "https://example.com/default_profile_image.png") {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.favoritePosts = []
        self.posts = []
    }

    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "username": username,
            "email": email,
            "profileImageUrl": profileImageUrl,
            "favoritePosts": favoritePosts,
            "posts": posts
        ]
    }
}
