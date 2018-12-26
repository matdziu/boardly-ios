//
//  BaseServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class BaseServiceImpl {
    
    let database = Database.database()
    let storage = Storage.storage()
    
    func getUserNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)")
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getCurrentUserId() -> String {
        return getCurrentUser()?.uid ?? ""
    }
    
    func getStorageProfilePictureRef(userId: String) -> StorageReference {
        return storage.reference().child(userId)
    }
}
