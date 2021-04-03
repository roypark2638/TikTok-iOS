//
//  NotificationUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

protocol NotificationUserFollowTableViewCellDelegate: AnyObject {
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell,
                                             didTapFollowFor username: String)
    func notificationUserFollowTableViewCell(_ cell: NotificationUserFollowTableViewCell,
                                             didTapAvatarFor username : String)
}

class NotificationUserFollowTableViewCell: UITableViewCell {
    // MARK: - Prop
    static let identifier = "NotificationUserFollowTableViewCell"
    
    weak var delegate: NotificationUserFollowTableViewCellDelegate?
    
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var username: String?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize
        )
        avatarImageView.layer.cornerRadius = iconSize/2
        avatarImageView.layer.masksToBounds = true
        
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: contentView.width - followButton.width - 40,
            y: 10,
            width: followButton.width + 30,
            height: 30
        )
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 30 - followButton.width - iconSize,
                height: contentView.height - 40
            )
        )
        label.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 5,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: label.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40
        )
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemGreen
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
    }

    // MARK: Methods
    
    func configure(with username: String, model: Notification) {
        self.username = username
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
    
    
    @objc func didTapAvatar() {
        guard let username = username else { return }
        delegate?.notificationUserFollowTableViewCell(self,
                                                      didTapAvatarFor: username)
    }
    
    @objc private func didTapFollow() {
        guard let username = username else { return }
        
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationUserFollowTableViewCell(self,
                                                      didTapFollowFor: username)
    }
}
