//
//  CommentViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

protocol CommentViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentViewController)
}

class CommentViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
        return tableView
    }()
    
    weak var delegate: CommentViewControllerDelegate?
    
    private var comments = [PostComment]()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.layoutIfNeeded()
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()
    
    init(post: PostModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(closeButton)
        view.addSubview(tableView)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 45, y: 10, width: 35, height: 35)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height - closeButton.bottom)
    }
    
    private func fetchPostComments() {
        self.comments = PostComment.mockComments()
        
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }

}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
