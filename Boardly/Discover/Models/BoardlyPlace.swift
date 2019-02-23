//
//  BoardlyPlace.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct BoardlyPlace: Equatable {
    var id: String = ""
    var adminId: String = ""
    var name: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var locationName: String = ""
    var placeLatitude: Double = 0.0
    var placeLongitude: Double = 0.0
    var phoneNumber: String = ""
    var pageLink: String = ""
    var collectionId: String = ""
    
    init(id: String = "",
         adminId: String = "",
         name: String = "",
         description: String = "",
         imageUrl: String = "",
         locationName: String = "",
         placeLatitude: Double = 0.0,
         placeLongitude: Double = 0.0,
         phoneNumber: String = "",
         pageLink: String = "",
         collectionId: String = "") {
        self.id = id
        self.adminId = adminId
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.locationName = locationName
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.phoneNumber = phoneNumber
        self.pageLink = pageLink
        self.collectionId = collectionId
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : Any] ?? [:]
        self.id = snapshot.key
        self.adminId = value["adminId"] as? String ?? ""
        self.name = value["name"] as? String ?? ""
        self.description = value["description"] as? String ?? ""
        self.imageUrl = value["imageUrl"] as? String ?? ""
        self.locationName = value["locationName"] as? String ?? ""
        self.placeLatitude = value["placeLatitude"] as? Double ?? 0.0
        self.placeLongitude = value["placeLongitude"] as? Double ?? 0.0
        self.phoneNumber = value["phoneNumber"] as? String ?? ""
        self.pageLink = value["pageLink"] as? String ?? ""
        self.collectionId = value["collectionId"] as? String ?? ""
    }
    
    func toDict() -> [String: Any] {
        return ["id" : id,
                "adminId": adminId,
                "name": name,
                "description": description,
                "imageUrl": imageUrl,
                "locationName": locationName,
                "placeLatitude": placeLatitude,
                "placeLongitude": placeLongitude,
                "phoneNumber": phoneNumber,
                "pageLink": pageLink,
                "collectionId": collectionId]
    }
}
