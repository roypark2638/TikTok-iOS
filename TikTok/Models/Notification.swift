//
//  Notification.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import Foundation

enum NotificationType{
    case userFollow(username: String)
    case postLike(postName: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .userFollow: return "userFollow"
        case .postLike: return "postLike"
        case .postComment: return "postComment"
        }
    }
}

class Notification {
    var identifier = UUID().uuidString
    var isHidden = false
    let text: String
    let type: NotificationType
    let date: Date
    
    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    static func mockData() -> [Notification] {
        
        let first = Array(0...3).compactMap({
            Notification(
                text: "Notification: \($0)",
                type: .postLike(postName: "Good Post"),
                date: Date()
            )
        })
        
        let second = Array(0...3).compactMap({
            Notification(
                text: "Notification: \($0)",
                type: .postComment(postName: "How are you"),
                date: Date()
            )
        })
        
        let third = Array(0...3).compactMap({
            Notification(
                text: "Notification: \($0)",
                type: .userFollow(username: "Roy Park"),
                date: Date()
            )
        })
        
        return first + second + third
        
    }
    
}
