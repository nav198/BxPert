//
//  UsersVC.swift
//  Bxpert
//
//  Created by Naveen on 31/03/25.
//

import UIKit

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = UsersViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UsersTBCell.self, forCellReuseIdentifier: UsersTBCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Users"
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        viewModel.onUsersUpdated = { [weak self] in
                   self?.tableView.reloadData()
               }
               
               viewModel.fetchUsers()
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UsersTBCell.identifier, for: indexPath) as? UsersTBCell else {
            return UITableViewCell()
        }
        let user = viewModel.user(at: indexPath.row)
                cell.configure(with: user)
                return cell
    }
}
