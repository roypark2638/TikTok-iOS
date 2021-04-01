//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Roy Park on 3/22/21.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let imageView: UIImage?
    let title: String
    let handler: (() -> Void) // something happens, and we can tap on that cell
}
