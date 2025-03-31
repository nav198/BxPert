//
//  UsersViewModel.swift
//  Bxpert
//
//  Created by Naveen on 31/03/25.
//

import Foundation

class UsersViewModel {
    
    private var users: [UserModel] = []
    
    var onUsersUpdated: (() -> Void)?
    
    func fetchUsers() {
        if let user = UserManager.shared.fetchUser() {
            self.users = [user] 
        }
        
        DispatchQueue.main.async {
            self.onUsersUpdated?()
        }
    }
    
    func numberOfUsers() -> Int {
        return users.count
    }
    
    func user(at index: Int) -> UserModel {
        return users[index]
    }
}
