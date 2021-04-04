//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit
import ProgressHUD

// this should be reusable controller based on the different user objects every time.
// we don't need to create new screen but load different data
class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return username.lowercased() == user.username.lowercased()
        }
        return false
    }
    
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
    
    private var posts = [PostModel]()
    
    
    // MARK: - Init
    
    var user: User
    
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
        fetchPosts()
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
    
    private func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] (postModels) in
            DispatchQueue.main.async {
                self?.posts = postModels
                self?.collectionView.reloadData()
            }
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
        return posts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
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
        let viewModel = ProfileHeaderViewModel(
            profileImageURL: user.profilePictureURL,
            followerCount: 10,
            followingCount: 20,
            isFollowing: isCurrentUserProfile ? nil : false
        )
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
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        
        guard isCurrentUserProfile else { return }
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("Error is occuring guarding the image")
            return }
        
        ProgressHUD.show("Uploading")
        // upload and update UI
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    
                    strongSelf.user = User(
                        username: strongSelf.user.username,
                        profilePictureURL: downloadURL,
                        identifier: strongSelf.user.username
                    )
                    ProgressHUD.showSuccess("Uploaded!")
                    strongSelf.collectionView.reloadData()
                    
                case .failure(let error):
                    ProgressHUD.showError("Failed to upload profile picture.")
                }
            }
        }
    }
}
