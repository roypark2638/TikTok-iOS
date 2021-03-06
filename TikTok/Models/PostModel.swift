//
//  PostModel.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import Foundation

struct PostModel {
    let identifier: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    
    var isLikedByCurrentUser = false
    
    // debug model
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString,
                                 user: User(
                                    username: "RoyPark",
                                    profilePictureURL: nil,
                                    identifier: UUID().uuidString
                                 ))
            posts.append(post)
        }
        return posts
    }
    
    // computed property to get the child path
    var videoChildPath: String {
        return "videos/\(user.username.lowercased())/\(fileName)"
    }
}
