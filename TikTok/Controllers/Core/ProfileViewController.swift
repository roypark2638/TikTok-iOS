//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

// this should be reusable controller based on the different user objects every time.
// we don't need to create new screen but load different data
class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        collection.register(PostCollectionViewCell.self,
                            forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        return collection
    }()

    
    
    // MARK: - Init
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        

        configureNavigationBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        let username = UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "ME"
        if title == username {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingsButton))
        }
    }
    
    // MARK: - Objc Methods
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        )   as? PostCollectionViewCell else {
                return UICollectionViewCell()
            }
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open post
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        let viewModel = ProfileHeaderViewModel(profileImageURL: nil, followerCount: 10, followingCount: 20, isFollowing: false)
        header.configure(with: viewModel)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        
        if self.user.username == currentUsername {
            // Edit Profile
        }
        else {
            // Follow or unfollow current users profile that we are viewing
            
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButton viewModel: ProfileHeaderViewModel) {
        
    }
    
    
}
