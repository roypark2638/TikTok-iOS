//
//  NotificationPostCommentTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

class NotificationPostCommentTableViewCell: UITableViewCell {
    // MARK: - Prop
    static let identifier = "NotificationPostCommentTableViewCell"
    
    private let postThumbnailImageView: UIImageView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
    }
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
    }

    // MARK: Methods
    
    func configure(with postName: String) {
        postThumbnailImageView.image = nil
        label.text = nil
    }
}
