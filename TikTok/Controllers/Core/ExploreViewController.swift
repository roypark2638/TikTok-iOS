//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit




class ExploreViewController: UIViewController {
    
    // SetUp the search bar globally in this class so other func can access
    // very similar to UITextField
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.layer.cornerRadius = 8.0
        bar.layer.masksToBounds = true // this enables to show the cornerRadius
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func configureModels() {

        // Banners
        var cells = [ExploreCell]()
        for _ in 0...100 {
            let cell = ExploreCell.banner(
                viewModel: ExploreBannerViewModel(
                    imageView: nil,
                    title: "test",
                    handler: {
                    }
                )
            )
            cells.append(cell)
        }
        
        
        sections.append(
            ExploreSection(
                type: .banners,
                cells: cells
            )
        )
        
        // Trending Posts
        var trendingCells = [ExploreCell]()
        for _ in 0...100 {
            let cell = ExploreCell.post(
                viewModel: ExplorePostViewModel(
                    thumbnailImage: nil,
                    caption: "tset",
                    handler: {
            }))
            trendingCells.append(cell)
        }
        
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: trendingCells
            )
        )
        // Users
        sections.append(
            ExploreSection(
                type: .user,
                cells: [
                    .user(
                        viewModel: ExploreUserViewModel(
                            profilePictureURL: nil,
                            username: "roy",
                            followerCount: 10,
                            handler: {
                    })),
                    .user(
                        viewModel: ExploreUserViewModel(
                            profilePictureURL: nil,
                            username: "park",
                            followerCount: 20,
                            handler: {
                    })),
                    .user(
                        viewModel: ExploreUserViewModel(
                            profilePictureURL: nil,
                            username: "jasmine",
                            followerCount: 30,
                            handler: {
                    })),
                    .user(
                        viewModel: ExploreUserViewModel(
                            profilePictureURL: nil,
                            username: "jow",
                            followerCount: 40,
                            handler: {
                    }))
                ]
            )
        )
        
        // Trending Hashtag
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: [
                    .hashtag(
                        viewModel: ExploreHashtagViewModel(
                            text: "#TikTok",
                            icon: nil,
                            count: 1,
                            handler: {
                    })),
                    .hashtag(
                        viewModel: ExploreHashtagViewModel(
                            text: "#App",
                            icon: nil,
                            count: 2,
                            handler: {
                    })),
                    .hashtag(
                        viewModel: ExploreHashtagViewModel(
                            text: "#SF",
                            icon: nil,
                            count: 3,
                            handler: {
                    })),
                    .hashtag(
                        viewModel: ExploreHashtagViewModel(
                            text: "#Korea",
                            icon: nil,
                            count: 4,
                            handler: {
                    }))
                ]
            )
        )
        
        // Recommended
        sections.append(
            ExploreSection(
                type: .recommended,
                cells: [
                .post(
                    viewModel: ExplorePostViewModel(
                        thumbnailImage: nil,
                        caption: "first caption",
                        handler: {
                })),
                .post(
                    viewModel: ExplorePostViewModel(
                        thumbnailImage: nil,
                        caption: "second caption",
                        handler: {
                })),
                .post(
                    viewModel: ExplorePostViewModel(
                        thumbnailImage: nil,
                        caption: "3 caption",
                        handler: {
                })),
                .post(
                    viewModel: ExplorePostViewModel(
                        thumbnailImage: nil,
                        caption: "4 caption",
                        handler: {
                })),
                .post(
                    viewModel: ExplorePostViewModel(
                        thumbnailImage: nil,
                        caption: "5 caption",
                        handler: {
                }))
            ]
            )
        )
        
        // Popular
        sections.append(
            ExploreSection(
                type: .popular,
                cells: [
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "first caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "second caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "3 caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "4 caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "5 caption",
                            handler: {
                    }))
                ]
            )
        )
        
        // New
        sections.append(
            ExploreSection(
                type: .new,
                cells: [
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "first caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "second caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "3 caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "4 caption",
                            handler: {
                    })),
                    .post(
                        viewModel: ExplorePostViewModel(
                            thumbnailImage: nil,
                            caption: "5 caption",
                            handler: {
                    }))
                ]
            )
        )
        
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.90),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        case .user:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(100)
                ),
                subitems: [item]
            )
            
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)
                ),
                subitems: [item]                
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            
            // Return
            return sectionLayout
        
        case .trendingPosts, .recommended, .new:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(240)
                ),
                subitem: item,
                count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(240)),
                subitems: [verticalGroup]
            )
            
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        case .popular :
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(170)),
                subitems: [item]
            )
            
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
        
        }
        
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        
        cell.backgroundColor = .red
        return cell
    }
    
    
}

extension ExploreViewController: UISearchBarDelegate {
    
}
