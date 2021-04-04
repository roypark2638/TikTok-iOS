//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Prop
    
    private let noNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notification"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        // when it's empty, default tableView is hidden.
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.register(
            NotificationUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationUserFollowTableViewCell.identifier
        )
        table.register(
            NotificationPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationPostLikeTableViewCell.identifier
        )
        table.register(
            NotificationPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationPostCommentTableViewCell.identifier
        )
        
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noNotificationLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.backgroundColor = .systemBackground
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
        
        fetchNotifications()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    // MARK: - Methods
    private func fetchNotifications() {
        DatabaseManager.shared.getNotifications { [weak self] (notifications) in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Objc Methods
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        
        
        DatabaseManager.shared.getNotifications(completion: { [weak self] (notifications) in
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        })
                
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationUserFollowTableViewCell.identifier,
                for: indexPath
            ) as? NotificationUserFollowTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: username, model: model)
            return cell
            
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationPostLikeTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationPostLikeTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationPostCommentTableViewCell.identifier,
                    for: indexPath
            ) as? NotificationPostCommentTableViewCell
            else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        }
                
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let model = notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self]success in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({ $0.isHidden == false }) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension NotificationsViewController: NotificationUserFollowTableViewCellDelegate {
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { (success) in
            if !success {
                print("Something failed")
            }
        }
    }
    
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(user: User(username: username,
                                                  profilePictureURL: nil,
                                                  identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension NotificationsViewController: NotificationPostLikeTableViewCellDelegate {
    func notificationPostLikeTableViewCell(_ cell: NotificationPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController: NotificationPostCommentTableViewCellDelegate {
    func notificationPostCommentTableViewCell(_ cell: NotificationPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        // first resolve the post model from database
        let vc = PostViewController(model: PostModel(identifier: identifier, user: User(
            username: "RoyPark",
            profilePictureURL: nil,
            identifier: UUID().uuidString
         )))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
