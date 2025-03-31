//
//  MakeAPICall.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import UIKit

class MobileVC: UIViewController {

    let mobileVM = MobilesViewModel()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imagesArray: [UIImage] = ["a1", "a2", "a3","a4","a5", "a6", "a7","a8","a9", "a10", "a11","a12","a13"]
        .compactMap { UIImage(named: $0) }


    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray5
        title = "Mobiles"
        setupStackView()
        bindViewModel()
        mobileVM.getData()
    }

    private func setupStackView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func bindViewModel() {
        showIndicator()
        mobileVM.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.hideIndicator()
                self?.updateGridView()
            }
        }
    }

    private func updateGridView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let itemsPerRow = 2
        var currentRowStack: UIStackView?

        for (index, mobile) in mobileVM.mobilesList.enumerated() {
            if index % itemsPerRow == 0 {
                currentRowStack = createRowStackView()
                stackView.addArrangedSubview(currentRowStack!)
            }

            let image = index < imagesArray.count ? imagesArray[index] : nil
            let itemView = createMobileItemView(for: mobile, image: image, row: index, target: self)
            currentRowStack?.addArrangedSubview(itemView)
        }
    }


    private func createRowStackView() -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 10
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually
        return rowStack
    }

    private func createMobileItemView(for mobile: MobilesModel, image: UIImage?, row: Int, target: Any) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = mobile.name
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "pencil.fill"), for: .normal)
        editButton.tintColor = .systemBlue
        editButton.tag = row
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(target, action: #selector(didTapEdit(sender:)), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.tag = row
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(target, action: #selector(didTapDelete(sender:)), for: .touchUpInside)

        containerView.addSubview(imageView)
        containerView.addSubview(label)
        containerView.addSubview(editButton)
        containerView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),

            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 60),

            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),

            editButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            editButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -20),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            deleteButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            deleteButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),

            containerView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 15)
        ])

        return containerView
    }

    
    @objc private func didTapEdit(sender: UIButton) {
        let row = sender.tag
        let mobile = mobileVM.mobilesList[row]

        let alert = UIAlertController(title: "Edit Mobile Name",
                                      message: "Enter a new name",
                                      preferredStyle: .alert)

        // Add text field
        alert.addTextField { textField in
            textField.text = mobile.name
        }

        // Add Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Add Save action
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self, let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            
            // Update mobile name in ViewModel
            self.mobileVM.updateItem(at: row, newName: newName)

            // Refresh UI
            self.updateGridView()
        }))

        present(alert, animated: true, completion: nil)
    }


    @objc private func didTapDelete(sender: UIButton) {
        let row = sender.tag
        let alert = UIAlertController(title: "Delete Mobile",
                                      message: "Are you sure you want to delete this \(self.mobileVM.mobilesList[sender.tag])?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.showIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.mobileVM.deleteItem(at: row)
                self.hideIndicator()
            })
            
        }))
        
        present(alert, animated: true, completion: nil)
    }


}
