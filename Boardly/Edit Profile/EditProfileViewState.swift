//
//  EditProfileViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct EditProfileViewState: Equatable {
    var progress: Bool = false
    var successfulUpdate: Bool = false
    var nameFieldEmpty: Bool = false
    var profileData: ProfileData = ProfileData()
    var render: Bool = true
    
    init(progress: Bool = false,
         successfulUpdate: Bool = false,
         nameFieldEmpty: Bool = false,
         profileData: ProfileData = ProfileData(),
         render: Bool = true) {
        self.progress = progress
        self.successfulUpdate = successfulUpdate
        self.nameFieldEmpty = nameFieldEmpty
        self.profileData = profileData
        self.render = render
    }
}
