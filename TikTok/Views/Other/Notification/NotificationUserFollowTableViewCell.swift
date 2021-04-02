//
//  NotificationUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

class NotificationUserFollowTableViewCell: UITableViewCell {
    // MARK: - Prop
    static let identifier = "NotificationUserFollowTableViewCell"
    
    // avatar, label, follow button
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = . systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
    }

    // MARK: Methods
    
    func configure(with username: String) {
        avatarImageView.image = nil
        label.text = nil
    }
}
