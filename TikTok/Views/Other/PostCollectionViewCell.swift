//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by Roy Park on 3/25/21.
//

import UIKit
import AVFoundation

class PostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PostCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.addSubview(spinner)
        backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        contentView.addSubview(imageView)        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        spinner.frame = CGRect(
            x: 0,
            y: 0,
            width: 60,
            height: 60
        )
        spinner.center = imageView.center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    // we are going to call configure on the main thread.
    // this thumbnail generator is heavy operation.
    // If you can extend the app to save the thumbnail at the time of the upload, it would be more ideal.
    // but this solution is acceptable as well.
    func configure(with post: PostModel) {
        // Derive child path
        // Get download url
        StorageManager.shared.getDownloadURL(for: post) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.removeFromSuperview()
                switch result {
                case .success(let url):
                    // Generate thumbnail
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        self?.imageView.image = UIImage(cgImage: cgImage)
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print("failed to get download url \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}




