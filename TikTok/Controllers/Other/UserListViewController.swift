//
//  UserListViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

// we are going to list your followers and following
// responsible to show a list with a table view of respective things we are trying to look at
class UserListViewController: UIViewController {
    
    public var users = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private let noUserLabel: UILabel = {
        let label = UILabel()
        label.text = "No users"
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    enum ListType: String {
        case followers
        case following
    }
    
    let type: ListType
    let user: User
    
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        if users.isEmpty {
            view.addSubview(noUserLabel)
        }
        else {
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == view {
            tableView.frame = view.bounds
        }
        else {
            noUserLabel.sizeToFit()
            noUserLabel.center = view.center
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let username = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemPink
        cell.textLabel?.text = username.lowercased()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
