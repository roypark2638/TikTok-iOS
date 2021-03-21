//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    enum DatabaseError: Error {
        case insertingError
    }
    
    // Public
    
    public func insertUser(with email: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        /*
         users: {
         "roypark": {
         email
         posts: []
         }
         }
         */
        // users -> {}
        // get current users key
        // if that exists, insert new entry
        // else create root users
        
        database.child("users").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            //            print(snapshot.value)
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                // create users root node
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]
                ) { (error, _) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else {
                        completion(.success(email))
                        return
                    }
                    
                    
                }
                return
            }
            
            usersDictionary[username] = ["email": email]
            //            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { (error, _) in
            //                guard error == nil else {
            //                    completion(false)
            //                    return
            //                }
            //
            //                completion(true)
            //
            //            })
            
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { (error, _) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(email))
                return
            })
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
