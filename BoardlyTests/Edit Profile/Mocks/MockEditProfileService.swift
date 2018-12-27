//
//  MockEditProfileService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockEditProfileService: EditProfileService {
    
    func getProfileData() -> Observable<ProfileData> {
        return Observable.just(ProfileData(name: "Matt", profilePictureUrl: "picture/url", rating: 5.0))
    }
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<Bool> {
        return Observable.just(true)
    }
}
