//
//  AuthButton.swift
//  TikTok
//
//  Created by Roy Park on 3/19/21.
//

import UIKit

class AuthButton: UIButton {
    
    enum ButtonType {
        case signIn
        case signUp
        case plain
        
        var title: String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plain: return "-"
            }
        }
    }
    
    private let type: ButtonType

    init(type: ButtonType, title: String?) {
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        setTitleColor(.systemBackground, for: .normal)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        if type == .signIn {
            setTitle(type.title, for: .normal)
            backgroundColor = .systemBlue
        }
        
        else if type == .signUp {
            setTitle(type.title, for: .normal)
            backgroundColor = .systemGreen
        }
        
        else if type == .plain {
            backgroundColor = .clear
            setTitleColor(.link, for: .normal)
        }
        
    }

}
