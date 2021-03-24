//
//  ExploreManager.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import Foundation
import UIKit

final class ExploreManager {
    static let shared = ExploreManager()
    
    // MARK: - Public
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        
        
        return exploreData.banners.compactMap({
            ExploreBannerViewModel(
                imageView: UIImage(named: $0.image),
                title: $0.title
            ) {
                // Completion
            }
            
        })
    }
    
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        
        return exploreData.creators.compactMap({
            ExploreUserViewModel(
                profilePicture: (UIImage(named: $0.image)),
                username: $0.username,
                followerCount: $0.followers_count
                ) {
                    // Completion
                }
        
        })
    }
    
    // MARK: - Private
    
    // responsible for taking the JSON file, parsing it, saving it as a local model
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else { return nil }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(ExploreResponse.self, from: data)
            return result
        }
        catch {
            print(error)
            return nil
        }
    }
    
}

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}

