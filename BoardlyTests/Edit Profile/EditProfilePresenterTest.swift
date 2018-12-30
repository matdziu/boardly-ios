//
//  EditProfilePresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick

class EditProfilePresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var editProfilePresenter: EditProfilePresenter!
        var editProfileViewRobot: EditProfileViewRobot!
        let testProfileData = ProfileData(name: "Matt", profilePictureUrl: "picture/url", rating: 5.0)
        
        beforeEach {
            editProfilePresenter = EditProfilePresenter(editProfileInteractor: MockEditProfileInteractor())
            editProfileViewRobot = EditProfileViewRobot(editProfilePresenter: editProfilePresenter)
        }
        
        describe("EditProfilePresenter") {
            
            it("successfully fetches initial data") {
                editProfileViewRobot.emitInitialFetchTrigger()
                editProfileViewRobot.assert(expectedViewStates: [
                    EditProfileViewState(),
                    EditProfileViewState(progress: true),
                    EditProfileViewState(profileData: testProfileData, render: true),
                    EditProfileViewState(profileData: testProfileData, render: false)])
            }
            
            it("shows name field error when user input name is empty") {
                editProfileViewRobot.emitInputData(inputData: EditProfileInputData(name: " ", profilePicture: nil))
                editProfileViewRobot.assert(expectedViewStates: [
                    EditProfileViewState(),
                    EditProfileViewState(nameFieldEmpty: true, render: false)])
            }
            
            it("shows success when user input name is correct") {
                editProfileViewRobot.emitInputData(inputData: EditProfileInputData(name: " Matt ", profilePicture: nil))
                editProfileViewRobot.assert(expectedViewStates: [
                    EditProfileViewState(),
                    EditProfileViewState(progress: true),
                    EditProfileViewState(successfulUpdate: true)])
            }
        }
    }
}
