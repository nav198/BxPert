//
//  SignInViewController.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//


import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore


class SignInViewController: UIViewController {
    private let viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
            view.backgroundColor = .white
            
            // App Logo
            let logoImageView = UIImageView(image: UIImage(named: "app-logo"))
            logoImageView.contentMode = .scaleAspectFit

            // Google Sign-In Button
            let googleSignInButton = GIDSignInButton()
            googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)

            // Stack View
            let stackView = UIStackView(arrangedSubviews: [logoImageView, googleSignInButton])
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(stackView)

            NSLayoutConstraint.activate([
                logoImageView.widthAnchor.constraint(equalToConstant: 200),
                logoImageView.heightAnchor.constraint(equalToConstant: 200),

                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    @objc private func handleGoogleSignIn() {
        showIndicator()
           viewModel.signInWithGoogle()
       }

    
    private func bindViewModel() {
           viewModel.onSignInSuccess = { [weak self] user in
               self?.hideIndicator()
               print("User signed in successfully: \(user.name)")
               self?.navigateToHomeScreen(user: user)
           }
           
           viewModel.onSignInFailure = { error in
               print("Sign-in failed: \(error)")
           }
       }
    
    private func navigateToHomeScreen(user: UserModel) {
        let homeViewModel = HomeViewModel(user: user)
        let homeVC = HomeViewController(viewModel: homeViewModel)
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
