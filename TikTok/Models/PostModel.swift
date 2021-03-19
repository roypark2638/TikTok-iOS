//
//  PostModel.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import Foundation

struct PostModel {
    let identifier: String
    
    var isLikedByCurrentUser = false
    
    // debug model
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
