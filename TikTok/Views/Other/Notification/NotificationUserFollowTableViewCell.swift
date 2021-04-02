//
//  NotificationUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import UIKit

class NotificationUserFollowTableViewCell: UITableViewCell {
    static let identification = "NotificationUserFollowTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
