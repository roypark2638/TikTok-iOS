//
//  NotificationPostCommentTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

protocol NotificationPostCommentTableViewCellDelegate: AnyObject {
    func notificationPostCommentTableViewCell(_ cell: NotificationPostCommentTableViewCell,
                                              didTapPostWith identifier: String)
}

class NotificationPostCommentTableViewCell: UITableViewCell {
    // MARK: - Prop
    static let identifier = "NotificationPostCommentTableViewCell"
    
    weak var delegate: NotificationPostCommentTableViewCellDelegate?
    
    var postID: String?
    
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
    }
    

    
    // MARK: - Init
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = 50
        postThumbnailImageView.frame = CGRect(
            x: contentView.width - 50,
            y: 3,
            width: iconSize,
            height: iconSize
        )

        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 30 - postThumbnailImageView.width - 5,
                height: contentView.height - 40
            )
        )
        label.frame = CGRect(
            x: 10,
            y: 5,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: 10,
            y: label.bottom + 3,
            width: contentView.width - postThumbnailImageView.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    
    }

    // MARK: Methods
    
    func configure(with postName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "logo")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        postID = postName
    }
    
    @objc private func didTapPost() {
        print("you tapped Comment")
        guard let id = postID else { return }
        delegate?.notificationPostCommentTableViewCell(self, didTapPostWith: id)
    }
}
