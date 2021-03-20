//
//  AuthField.swift
//  TikTok
//
//  Created by Roy Park on 3/19/21.
//

import UIKit

class AuthField: UITextField {
    
    // we want this field to be re-usable
    enum FieldType {
        case email
        case password
        
        var title: String {
            switch self {
            case .email: return "Email Address"
            case .password: return "Password"
            }
        }
    }
    
    private let type: FieldType

    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        placeholder = type.title
        layer.cornerRadius = 8
        layer.masksToBounds = true
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
        if type == .password {
            isSecureTextEntry = true
        }
        else if type == .email {
            keyboardType = .emailAddress
        }
    }
    

}
