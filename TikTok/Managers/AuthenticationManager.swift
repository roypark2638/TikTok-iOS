//
//  AuthenticationManager.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import Foundation
import FirebaseAuth

struct AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case Facebook
        case Google
    }
    
    // Public
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func SignIn(with method: SignInMethod) {
        
    }
    
    
    /// Signing out the current user
    /// - Parameter completion: async callback to return true or false based on the result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
        
    }
}
