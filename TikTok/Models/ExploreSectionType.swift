//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import Foundation

// CaseIterable for iterate the cases
enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case user
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        case .banners:
            return "Features"
        case .trendingPosts:
            return "Trending Videos"
        case .user:
            return "Popular Creators"
        case .trendingHashtags:
            return "Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}
