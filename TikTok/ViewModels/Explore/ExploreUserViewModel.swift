//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import Foundation
import UIKit


struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void) // something happens, and we can tap on that cell
}

