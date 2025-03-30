//
//  LoadingIndicator.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation

import UIKit

extension UIViewController {
    private static var activityIndicator: UIActivityIndicatorView?

    func showIndicator() {
        if UIViewController.activityIndicator != nil { return }

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.startAnimating()

        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150) 
        ])

        UIViewController.activityIndicator = indicator
    }


    func hideIndicator() {
        UIViewController.activityIndicator?.stopAnimating()
        UIViewController.activityIndicator?.removeFromSuperview()
        UIViewController.activityIndicator = nil
    }
}
