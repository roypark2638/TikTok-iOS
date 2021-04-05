//
//  PostViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var model: PostModel
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "This is the first label that I made in the app #first #post"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    // to send back our video that we are playing
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    var player: AVPlayer?
    
    // When user watched video to the end, replay again
    private var playerDidFinishObserver: NSObjectProtocol?
    
    // MARK: - Init
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // first subview on Z
        view.addSubview(videoView)
        videoView.addSubview(spinner)
        configureVideo()
                
        view.backgroundColor = .black
        
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoView.frame = view.bounds
        spinner.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 100
        )
        spinner.center = videoView.center
        
        let size: CGFloat = 40
        //        let tapBarHeight: CGFloat = tabBarController?.tabBar.height ?? 0
        let yStart: CGFloat = view.height - (size * 5.0) - 15.0 - view.safeAreaInsets.bottom
        for (index, button) in [profileButton, likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width-size-10,
                                  y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size),
                                  width: size,
                                  height: size)
        }
        captionLabel.sizeToFit() // automatically set the size
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 15, height: view.height))
        captionLabel.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - labelSize.height - 10,
            width: view.width - size - 20,
            height: labelSize.height
        )
        
        profileButton.layer.cornerRadius = size / 2
    }
    
    private func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(shareButton)
        view.addSubview(commentButton)
        view.addSubview(profileButton)
        
        likeButton.addTarget(self, action: #selector(didTouchLike), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTouchShare), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTouchComment), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTouchProfile), for: .touchUpInside)
    }
    
    private func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func configureVideo() {
        StorageManager.shared.getDownloadURL(for: model) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.spinner.stopAnimating()
                strongSelf.spinner.removeFromSuperview()
                switch result {
                case .success(let url):
                    
                    strongSelf.player = AVPlayer(url: url)
                    // add this video to our post
                    
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                case .failure:
                    guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else { return }
                    let url = URL(fileURLWithPath: path)
                    self?.player = AVPlayer(url: url)
                    // add this video to our post
                    
                    let playerLayer = AVPlayerLayer(player: self?.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                }
            }
        }
        guard let player = player else { return }
        
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main,
            using: { (_) in
                
                player.seek(to: .zero)
                player.play()
            }
        )
    }
    
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { (done) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                if done {
                    UIView.animate(withDuration: 0.2) {
                        imageView.alpha = 0
                    } completion: { (done) in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                    
                }
            }
        }
    }
    
    @objc private func didTouchLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTouchShare() {
        guard let url = URL(string: "https://www.tiktok.com") else { return }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        present(vc, animated: true)
    }
    
    @objc private func didTouchComment() {
        // the reason why we are using the delegate is that we want to display the comment tray and have control of pageVC to manage some features
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTouchProfile() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
}
