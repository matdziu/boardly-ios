//
//  MockEditProfileInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockEditProfileInteractor: EditProfileInteractor {
    
    func fetchProfileData() -> Observable<PartialEditProfileViewState> {
        let testProfileData = ProfileData(name: "Matt", profilePictureUrl: "picture/url", rating: 5.0)
        return Observable.just(PartialEditProfileViewState.profileDataFetched(
            profileData: testProfileData, render: false)).startWith(
                PartialEditProfileViewState.profileDataFetched(
                    profileData: testProfileData, render: true))
    }
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<PartialEditProfileViewState> {
        return Observable.just(PartialEditProfileViewState.successfulUpdate)
    }
}
