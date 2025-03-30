//
//  HomeVC.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//
import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private let profileImageView = UIImageView()
    private let welcomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.label
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var topView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 227/255, green: 46/255, blue: 103/255, alpha: 1.0)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.spacing = 10
           stackView.distribution = .fillEqually
           stackView.translatesAutoresizingMaskIntoConstraints = false
           return stackView
       }()
       
    let buttonTitles = ["See PDF", "Image Capture", "Mobiles","Hello"]
    let systemImageNames = ["eye.fill", "camera.fill", "arrow.clockwise","circle.fill"]

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        welcomeLabel.text = viewModel.welcomeText
        view.addSubview(topView)
        view.addSubview(welcomeLabel)
        view.addSubview(profileImageView)
        view.addSubview(stackView)
        
        var currentRowStack: UIStackView?
        
        for index in 0..<buttonTitles.count {
            if index % 2 == 0 {
                currentRowStack = createRowStack()
                stackView.addArrangedSubview(currentRowStack!)
            }
            
            let customView = createCustomView(title: buttonTitles[index], systemImageName: systemImageNames[index], tag: index)

            currentRowStack?.addArrangedSubview(customView)
        }
        
        topView.layer.cornerRadius = 20
        topView.clipsToBounds = true

        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 80),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            profileImageView.topAnchor.constraint(equalTo:topView.bottomAnchor, constant: 10),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            welcomeLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 26),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),

        ])
    }
    
    private func bindViewModel() {
        viewModel.loadProfileImage { [weak self] image in
            self?.profileImageView.image = image
        }
        
        viewModel.onNavigate = { [weak self] destination in
            self?.navigate(to: destination)
        }
    }
    
    private func createRowStack() -> UIStackView {
           let rowStack = UIStackView()
           rowStack.axis = .horizontal
           rowStack.spacing = 10
           rowStack.distribution = .fillEqually
           return rowStack
       }
    
       
    private func createCustomView(title: String, systemImageName: String, tag: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray4
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false

  
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .systemBlue

        let label = UILabel()
        label.text = title
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(imageView)
        containerView.addSubview(label)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = tag

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])

        return containerView
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
            guard let tappedView = sender.view else { return }
            viewModel.handleButtonTap(at: tappedView.tag)
        }


    private func navigate(to destination: HomeNavigation) {
            switch destination {
            case .seeReport:
                let vc = PDFViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .camera:
                let vc = ImageCaptureVC()
                navigationController?.pushViewController(vc, animated: true)
            case .mobile:
                let vc = MobileVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
}


