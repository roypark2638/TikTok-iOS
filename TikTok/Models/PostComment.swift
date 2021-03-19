//
//  PostComment.swift
//  TikTok
//
//  Created by Roy Park on 3/19/21.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "Kanyewst",
            profilePictureURL: nil,
            identifier: UUID().uuidString)
        
        var comments = [PostComment]()
        
        let text = [
            "This is cool",
            "I LIKT IT",
            "Keep it up!"
        ]
        
        for comment in text {
            comments.append(
                PostComment(
                    text: comment,
                    user: user,
                    date: Date()
                ))
        }
        return comments
    }
}
