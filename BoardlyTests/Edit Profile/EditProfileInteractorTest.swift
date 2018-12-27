//
//  EditProfileInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 26/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble

class EditProfileInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let editProfileInteractor = EditProfileInteractorImpl(editProfileService: MockEditProfileService())
        
        describe("EditProfileInteractor") {
            it("successfully fetches profile data") {
                let output = try! editProfileInteractor.fetchProfileData()
                    .toBlocking()
                    .toArray()
                
                let testProfileData = ProfileData(name: "Matt", profilePicture: "picture/url", rating: 5.0)
                expect(output).to(equal([
                    PartialEditProfileViewState.profileDataFetched(profileData: testProfileData, render: true),
                    PartialEditProfileViewState.profileDataFetched(profileData: testProfileData, render: false)]))
            }
            
            it("successfully saves profile data") {
                let output = try! editProfileInteractor.saveProfileChanges(inputData: EditProfileInputData(name: "", profilePicture: nil))
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialEditProfileViewState.successfulUpdate]))
            }
        }
    }
}
