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
//        case Facebook
//        case Google
    }
    
    enum AuthError: Error {
        case SignInFailed
        case SignUpFailed
    }
    
    // Public
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func SignIn(with method: SignInMethod, email: String?, password: String?, completion: @escaping (Result<String, Error>) -> Void) {
        switch method {
        case .email:
            guard let email = email,
                  let password = password
            else { return }

            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    else {
                        completion(.failure(AuthError.SignInFailed))
                    }
                    return
                }
                
                completion(.success(email))
                
            }

//        case .Facebook: completion(true)
//
//        case .Google: completion(true)
        }
    }
    
    
    
    public func SignUp(with username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Make sure entered username is available 
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard result != nil, error == nil else {
                if let error = error {
                    print("From AuthManager")
                    print(error)
                    completion(.failure(error))
                    return
                }
                else {
                    completion(.failure(AuthError.SignUpFailed))
                }
                return
            
            }
            DatabaseManager.shared.insertUser(with: email, username: username, completion: completion)
            
        }
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
