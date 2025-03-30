//
//  SignInViewModel.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class SignInViewModel {
    var user: UserModel?
    var onSignInSuccess: ((UserModel) -> Void)?
    var onSignInFailure: ((String) -> Void)?
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            onSignInFailure?("Missing Firebase client ID.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            onSignInFailure?("Could not find view controller.")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard let user = result?.user, error == nil else {
                self.onSignInFailure?(error?.localizedDescription ?? "Google Sign-In failed.")
                return
            }
            
            guard let idToken = user.idToken?.tokenString else {
                self.onSignInFailure?("No ID token found.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.onSignInFailure?(error.localizedDescription)
                    return
                }
                
                if let authUser = authResult?.user {
                    let newUser = UserModel(
                        id: authUser.uid,
                        name: authUser.displayName ?? "No Name",
                        email: authUser.email ?? "No Email",
                        profilePicture: "\(authUser.photoURL)"
                    )
                    UserManager.shared.saveUser(newUser)
                                       self.user = newUser
                    self.onSignInSuccess?(newUser)
                }
            }
        }
    }
}
