//
//  CollectionGame.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct CollectionGame: Equatable {
    
    var id: String = ""
    var name: String = ""
    var yearPublished: String = ""
    var imageUrl: String = ""
    
    init(id: String = "",
         name: String = "",
         yearPublished: String = "",
         imageUrl: String = "") {
        self.id = id
        self.name = name
        self.yearPublished = yearPublished
        self.imageUrl = imageUrl
    }
}
