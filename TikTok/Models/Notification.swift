//
//  Notification.swift
//  TikTok
//
//  Created by Roy Park on 4/1/21.
//

import Foundation

struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(text: "Notification: \($0)", date: Date())
        })
    }
    
}
