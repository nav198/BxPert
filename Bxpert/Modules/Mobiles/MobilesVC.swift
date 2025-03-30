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
        view.backgroundColor = .systemBackground
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

    private func createMobileItemView(for mobile: MobilesModel, image: UIImage?,row:Int,target:Any) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray4
        containerView.layer.cornerRadius = 8

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 120)
        ])

        let label = UILabel()
        label.text = mobile.name
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .blue
        editButton.tag = row
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(target, action: #selector(didTapEdit(sender: )), for: .touchUpInside)

        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.tag = row
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(target, action: #selector(didTapDelete(sender:)), for: .touchUpInside)

        containerView.addSubview(label)
        containerView.addSubview(imageView)
        containerView.addSubview(editButton)
        containerView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),

            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            editButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),

            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            deleteButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 10),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),

            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            label.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 10)
        ])

        return containerView
    }
    
    @objc private func didTapEdit(sender: UIButton) {
        let row = sender.tag
    }

    @objc private func didTapDelete(sender: UIButton) {
        let row = sender.tag
        let alert = UIAlertController(title: "Delete Mobile",
                                      message: "Are you sure you want to delete this item?",
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
