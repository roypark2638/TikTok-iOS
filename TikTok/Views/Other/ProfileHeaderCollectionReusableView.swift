//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok
//
//  Created by Roy Park on 3/25/21.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButton viewModel: ProfileHeaderViewModel)
}


class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    var viewModel: ProfileHeaderViewModel?
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.setTitle("0\nFollowers", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.setTitle("0\nFollowing", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 1
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .center
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        return button
    }()
    
    // MARK: - Init
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
                
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super .layoutSubviews()
        setUpLayout()
    }
    
    // MARK: - Methods
    
    private func configureButtons() {
        followersButton.addTarget(self,
                                  action: #selector(didTapFollowers),
                                  for: .touchUpInside)
        followingButton.addTarget(self,
                                  action: #selector(didTapFollowing),
                                  for: .touchUpInside)
        primaryButton.addTarget(self,
                                  action: #selector(didTapPrimary),
                                  for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(profileImageView)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(primaryButton)
    }
    
    private func setUpLayout() {
        let imageSize: CGFloat = 100
        profileImageView.layer.cornerRadius = imageSize/2
        profileImageView.frame = CGRect(
            x: (width - imageSize)/2,
            y: 5,
            width: imageSize,
            height: imageSize
        ).integral
//        followersButton.sizeToFit()
//        let buttonSize = CGSize(width: width/4, height: followersButton.height)
        let buttonSize = width/4
        followersButton.frame = CGRect(
            x: (width - buttonSize*2)/2 - 5,
            y: profileImageView.bottom + 5,
            width: buttonSize,
            height: 60
        )
        
        followingButton.frame = CGRect(
            x: followersButton.right + 10,
            y: profileImageView.bottom + 5,
            width: buttonSize,
            height: 60
        )
        
        primaryButton.frame = CGRect(
            x: (width - buttonSize * 2)/2 - 5,
            y: followersButton.bottom + 5,
            width: buttonSize*2 + 10,
            height: 30
        )
        
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if let imageURL = viewModel.profileImageURL {
            profileImageView.sd_setImage(with: imageURL, completed: nil)
        }
        else {
            profileImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "UnFollow" : "Follow", for: .normal)
        }
        else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapFollowers() {
        guard let safeViewModel = viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapFollowersButton: safeViewModel)
    }
    
    @objc private func didTapFollowing() {
        guard let safeViewModel = viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapFollowersButton: safeViewModel)
    }
    
    @objc private func didTapPrimary() {
        guard let safeViewModel = viewModel else { return }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapPrimaryButtonWith: safeViewModel)
        
    }
}
