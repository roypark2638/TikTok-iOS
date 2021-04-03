//
//  StorageManager.swift
//  TikTok
//
//  Created by Roy Park on 3/18/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideo(from url: URL, fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url,
                                                                   metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
    
    public func generateVideoName() -> String {
        // we want to have unique video name for every single file we upload
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        // name of the file will also serve as a post identifier.
        return "\(uuidString)_\(number)_\(unixTimestamp).mov"
    }
}
