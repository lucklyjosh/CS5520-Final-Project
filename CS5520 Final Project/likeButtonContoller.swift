//
//  likeButtonContoller.swift
//  CS5520 Final Project
//
//  Created by Josh wen on 4/19/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension ViewController{
    func didTapLikeButton(on cell: ContentCardCell) {
        guard let indexPath = mainScreen.collectionView.indexPath(for: cell),
              let recipeId = recipes[indexPath.row].recipeId else {
            print("Error: Could not find index path or recipeId is nil")
            return
        }
        let isCurrentlyFavorited = recipes[indexPath.row].isFavorited

           print("Current button state before toggling: \(isCurrentlyFavorited)")

           toggleFavoriteStatus(for: recipeId, currentlyFavorited: isCurrentlyFavorited) { success in
               DispatchQueue.main.async {
                   if success {
                       let newFavoritedState = !isCurrentlyFavorited
                       cell.likeButton.isSelected = newFavoritedState
                       self.recipes[indexPath.row].isFavorited = newFavoritedState
                       print("Toggled button state to: \(newFavoritedState)")
                   } else {
                       // If the operation failed, revert the button state
                       cell.likeButton.isSelected = isCurrentlyFavorited
                       print("Failed to update the favorite status in Firestore.")
                   }
            }
        }
    }

    func toggleFavoriteStatus(for recipeId: String, currentlyFavorited: Bool, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not logged in.")
            completion(false)
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userId)
        let updateAction = currentlyFavorited ? FieldValue.arrayRemove([recipeId]) : FieldValue.arrayUnion([recipeId])

        userRef.updateData(["favoritePosts": updateAction]) { error in
            if let error = error {
                print("Error updating favorite posts: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Favorite status successfully updated for recipeId: \(recipeId) to \(currentlyFavorited ? "not favorited" : "favorited")")
                if let index = self.recipes.firstIndex(where: { $0.recipeId == recipeId }) {
                    self.recipes[index].isFavorited = !currentlyFavorited
                }
                NotificationCenter.default.post(name: NSNotification.Name("FavoriteStatusChanged"), object: nil, userInfo: ["recipeId": recipeId, "newStatus": !currentlyFavorited])
                completion(true)
            }
        }
    }
}
