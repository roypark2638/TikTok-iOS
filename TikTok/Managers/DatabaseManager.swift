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
    
    public func getNotifications(completion: @escaping ([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func follow(username: String, completion: @escaping (Bool) -> Void ) {
        completion(true)
    }
    
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { (snapshot) in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
                        
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        // get the current username
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return            
        }
        
        // use the username under our database username so we don't have to for loop.
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let newEntry = [
                "name": fileName,
                "caption": caption
            ]
            
            if var posts = value["posts"] as? [[String:Any]] {
                // if it's not the first one, append the new post onto the database posts
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                // when it's the first post on the user, create a new posts
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
    
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        let path = "users/\(user.username.lowercased())/posts"
        
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            
            let models: [PostModel] = posts.compactMap({
                var model = PostModel(identifier: UUID().uuidString, user: user)
                model.fileName = $0["name"] ?? ""
                model.caption = $0["caption"] ?? ""
                return model
            })
            
            completion(models)
        }
    }
}
