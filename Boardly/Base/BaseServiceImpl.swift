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
import GeoFire

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
    
    func getGeoFire(childPath: String) -> GeoFire {
        return GeoFire(firebaseRef: database.reference(withPath: childPath))
    }
    
    func getSingleEventNodeRef(eventId: String) -> DatabaseReference {
        return database.reference(withPath: "\(EVENTS_NODE)/\(eventId)")
    }
    
    func getUserCreatedEventsNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)/\(EVENTS_NODE)/\(CREATED_EVENTS_NODE)")
    }
}
