//
//  ProfileViewModel.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation
import UIKit

class HomeViewModel {
    private let user: UserModel
    
    var onNavigate: ((HomeNavigation) -> Void)?
    
    var welcomeText: String {
        return "Welcome, \(user.name)!"
    }
    
    var profilePictureURL: URL? {
        guard let profilePicture = user.profilePicture?
            .replacingOccurrences(of: "Optional(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        return URL(string: profilePicture)
    }
    
    init(user: UserModel) {
        self.user = user
    }
    
    func loadProfileImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = profilePictureURL else {
            DispatchQueue.main.async {
                completion(UIImage(systemName: "person.fill"))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let _ = self else { return }
            
            if let data, error == nil, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "person.fill"))
                }
            }
        }.resume()
    }
    
    func handleButtonTap(at index: Int) {
        let destination: HomeNavigation
        switch index {
        case 0: destination = .seeReport
        case 1: destination = .camera
        case 2: destination = .mobile
        default: return
        }
        onNavigate?(destination)
    }
    
}
