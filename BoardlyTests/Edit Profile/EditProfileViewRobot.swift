//
//  EditProfileViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class EditProfileViewRobot {
    
    private let mockEditProfileView = MockEditProfileView()
    
    init(editProfilePresenter: EditProfilePresenter) {
        editProfilePresenter.bind(editProfileView: mockEditProfileView)
    }
    
    func assert(expectedViewStates: [EditProfileViewState]) {
        expect(self.mockEditProfileView.renderedStates).to(equal(expectedViewStates))
    }
    
    func emitInitialFetchTrigger() {
        mockEditProfileView.fetchProfileTriggerSubject.onNext(true)
    }
    
    func emitInputData(inputData: EditProfileInputData) {
        mockEditProfileView.inputDataSubject.onNext(inputData)
    }
}
