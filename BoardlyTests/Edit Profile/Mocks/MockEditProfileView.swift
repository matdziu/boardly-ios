//
//  MockEditProfileView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
@testable import Boardly

class MockEditProfileView: EditProfileView {
 
    var renderedStates: [EditProfileViewState] = []
    let inputDataSubject = PublishSubject<EditProfileInputData>()
    let fetchProfileTriggerSubject = PublishSubject<Bool>()
    
    func inputDataEmitter() -> Observable<EditProfileInputData> {
        return inputDataSubject
    }
    
    func fetchProfileDataTriggerEmitter() -> Observable<Bool> {
        return fetchProfileTriggerSubject
    }
    
    func render(editProfileViewState: EditProfileViewState) {
        renderedStates.append(editProfileViewState)
    }
}
