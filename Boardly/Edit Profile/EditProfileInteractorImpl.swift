//
//  EditProfileInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EditProfileInteractorImpl: EditProfileInteractor {
    
    private let editProfileService: EditProfileService
    
    init(editProfileService: EditProfileService) {
        self.editProfileService = editProfileService
    }
    
    func fetchProfileData() -> Observable<PartialEditProfileViewState> {
        return editProfileService.getProfileData()
            .flatMap({ [unowned self] profileData in return self.emitProfileDataFetchedState(profileData: profileData) })
    }
    
    private func emitProfileDataFetchedState(profileData: ProfileData) -> Observable<PartialEditProfileViewState> {
        let profileFetchedState = PartialEditProfileViewState.profileDataFetched(profileData: profileData, render: false)
        let initialProfileFetchedState = PartialEditProfileViewState.profileDataFetched(profileData: profileData, render: true)
        return Observable.just(profileFetchedState).startWith(initialProfileFetchedState)
    }
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<PartialEditProfileViewState> {
        return editProfileService.saveProfileChanges(inputData: inputData)
            .map({ _ in return PartialEditProfileViewState.successfulUpdate })
    }
}
