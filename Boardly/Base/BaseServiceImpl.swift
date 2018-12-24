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

class BaseServiceImpl {
    
    let database = Database.database()
    
    func getUserNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)")
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getCurrentUserId() -> String {
        return getCurrentUser()?.uid ?? ""
    }
}
