//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

// this should be reusable controller based on the different user objects every time.
// we don't need to create new screen but load different data
class ProfileViewController: UIViewController {
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        
    }
    

}
