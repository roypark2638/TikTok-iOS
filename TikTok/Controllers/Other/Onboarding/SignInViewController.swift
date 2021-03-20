//
//  SignInViewController.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    // For user auth, this variable takes nothing and returns nothing
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .systemBackground
    }


}
