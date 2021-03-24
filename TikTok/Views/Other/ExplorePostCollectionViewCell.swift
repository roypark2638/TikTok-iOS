//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainImageView)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let captionHeight = contentView.height / 5
        mainImageView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height - captionHeight
        )
        titleLabel.frame = CGRect(
            x: 0,
            y: contentView.height - captionHeight,
            width: contentView.width,
            height: captionHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: ExplorePostViewModel) {
        mainImageView.image = viewModel.thumbnailImage
        titleLabel.text = viewModel.caption
    }

}
