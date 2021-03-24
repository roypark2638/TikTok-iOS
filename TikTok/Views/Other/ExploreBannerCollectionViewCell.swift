//
//  ExploreBannerCollectionViewCell.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import UIKit

class ExploreBannerCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreBannerCollectionViewCell"
    
    private let bannerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(bannerImage)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerImage.frame = contentView.bounds
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(
            x: 10,
            y: contentView.height - 5 - titleLabel.height,
            width: titleLabel.width,
            height: titleLabel.height
        )
        contentView.bringSubviewToFront(titleLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImage.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: ExploreBannerViewModel) {
        bannerImage.image = viewModel.imageView
        titleLabel.text = viewModel.title
    }
    
}
