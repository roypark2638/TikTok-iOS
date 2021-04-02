//
//  NotificationPostLikeTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

class NotificationPostLikeTableViewCell: UITableViewCell {
    
    // MARK: - Prop
    static let identifier = "NotificationPostLikeTableViewCell"
    
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
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
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
        postThumbnailImageView.image = nil
        label.text = nil
    }
    
    // MARK: Methods

    func configure(with postName: String) {
        postThumbnailImageView.image = nil
        label.text = nil
    }

}
