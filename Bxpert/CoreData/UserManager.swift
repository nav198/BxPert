//
//  UserManager.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation
import CoreData
import UIKit
import FirebaseAuth
//import FirebaseAuth

class UserManager {
    static let shared = UserManager()
    private init() {}

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Save User
    func saveUser(_ user: UserModel) {
        let entity = User(context: context)
        entity.id = user.id
        entity.name = user.name
        entity.email = user.email
        entity.profilePicture = "\(user.profilePicture)"

        do {
            try context.save()
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }

    // Fetch User
    func fetchUser() -> UserModel? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            if let user = try context.fetch(fetchRequest).first {
                return UserModel(
                    id: user.id ?? "",
                    name: user.name ?? "",
                    email: user.email ?? "",
                    profilePicture: "\(user.profilePicture ?? "")"
                )
            }
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
        return nil
    }

    // Delete User
    func deleteUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                context.delete(user)
            }
            try context.save()
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }
}
