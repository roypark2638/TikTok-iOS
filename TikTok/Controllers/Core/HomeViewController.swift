//
//  ViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties

    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        control.selectedSegmentIndex = 1
        return control
    }()
    
    let forYouPageViewController = UIPageViewController (
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let followingPageViewController = UIPageViewController (
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeader()
        horizontalScrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    private func setUpFeed() {
        horizontalScrollView.contentSize =  CGSize(width: view.width * 2, height: view.height)
        
        // For you
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    private func setUpHeader() {
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
        

    }
    
    private func setUpFollowingFeed() {
        guard let model = followingPosts.first else { return }
        
        followingPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil
        )
        // we want to add pagingController to be the child of the homeVC
        // this is the concept of the compositional controller
        followingPageViewController.dataSource = self
                        
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
        
        
    }

    private func setUpForYouFeed() {
        guard let model = forYouPosts.first else { return }
        
        forYouPageViewController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil
        )
        // we want to add pagingController to be the child of the homeVC
        // this is the concept of the compositional controller
        forYouPageViewController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width,
                                             y: 0,
                                             width: horizontalScrollView.width,
                                             height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
        
        
    }

}

// MARK: - UIPageViewControllerDataSource

extension HomeViewController: UIPageViewControllerDataSource {
    // give the VC before the current VC I am on
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // current post where the user is viewing
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        
        // get the index of the currentPost
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        // if this is the first post, then we can't show the VCBefore.
        if index == 0 {
            return nil
        }
        
        // get the previous VC and return it
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    // give the VC after the current VC I am on
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // current post where the user is viewing
        guard let fromPost = (viewController as? PostViewController)?.model else { return nil }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        // if the index is greater than the number of the contents we have, return nil
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        // else, get the next post
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    // computed property, check scroll view position and return it's posts
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // Following
            // we are all the way to the left
            return followingPosts
        }
        else {
            // For You
            return forYouPosts
        }
    }
}

// MARK: - UIScrollViewDelegate

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x < (view.width/2) {
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}
