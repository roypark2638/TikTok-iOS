//
//  CommentTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 3/19/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 12)
        // we will set the fixed size of the comment so that it doesn't ruin whole UI
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10)
        // we will set the fixed size of the comment so that it doesn't ruin whole UI
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(commentLabel)
        addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        usernameLabel.sizeToFit()
        
        // assign the frame
        let imageSize = CGFloat(30)
        avatarImageView.frame = CGRect(x: 8,
                                       y: 8,
                                       width: imageSize,
                                       height: imageSize)
        usernameLabel.frame = CGRect(x: avatarImageView.right + 6,
                                     y: 8,
                                     width: contentView.width / 2,
                                     height: 25)
        
        dateLabel.frame = CGRect(x: usernameLabel.right + 6,
                                 y: usernameLabel.height / 2,
                                 width: dateLabel.width,
                                 height: dateLabel.height)
        
        let commentLabelHeight = min(contentView.height - avatarImageView.bottom, commentLabel.height)
        
        commentLabel.frame = CGRect(x: 8,
                                    y: avatarImageView.bottom + 6,
                                    width: contentView.width - 16,
                                    height: commentLabelHeight)
        
        
    }
    
    // every time the table view wants to re-use the cell for another cell
    // we want to make sure we reset everything
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        usernameLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }
    
    public func configure(with model: PostComment) {
        commentLabel.text = model.text
        dateLabel.text = String.date(with: model.date)
        usernameLabel.text = model.user.username
        if let url = model.user.profilePictureURL {
            // download the pic and assign
            print(url)
        }
        else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
        
        
    }
}
