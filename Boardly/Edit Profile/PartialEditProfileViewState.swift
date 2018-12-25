//
//  PartialEditProfileViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialEditProfileViewState: Equatable {
    case progress
    case successfulUpdate
    case nameFieldEmpty
    case profileDataFetched(profileData: ProfileData, render: Bool)
    
    func reduce(previousState: EditProfileViewState) -> EditProfileViewState {
        switch self {
        case .progress:
            return EditProfileViewState(progress: true)
        case .successfulUpdate:
            return EditProfileViewState(successfulUpdate: true)
        case .nameFieldEmpty:
            return EditProfileViewState(nameFieldEmpty: true, render: false)
        case .profileDataFetched(let profileData, let render):
            var newState = previousState
            newState.profileData = profileData
            newState.render = render
            newState.progress = false
            return newState
        }
    }
}
