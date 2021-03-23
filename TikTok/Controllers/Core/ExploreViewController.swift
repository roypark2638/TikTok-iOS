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
        var cells = [ExploreCell]()
        for _ in 0...1000 {
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
            break
        case .trendingPosts:
            break
        case .user:
            break
        case .trendingHashtags:
            break
        case .recommended:
            break
        case .popular:
            break
        case .new:
            break
        }
        
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
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        
        cell.backgroundColor = .red
        return cell
    }
    
    
}

extension ExploreViewController: UISearchBarDelegate {
    
}
