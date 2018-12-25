//
//  EditProfileContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol EditProfileView {
    
    func render(editProfileViewState: EditProfileViewState)
    
    func inputDataEmitter() -> Observable<EditProfileInputData>
    
    func fetchProfileDataTriggerEmitter() -> Observable<Bool>
}

protocol EditProfileInteractor {
    
    func fetchProfileData() -> Observable<PartialEditProfileViewState>
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<PartialEditProfileViewState>
}

protocol EditProfileService {
    
    func getProfileData() -> Observable<ProfileData>
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<Bool>
}
