//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import Foundation
import UIKit


struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void) // something happens, and we can tap on that cell
}
