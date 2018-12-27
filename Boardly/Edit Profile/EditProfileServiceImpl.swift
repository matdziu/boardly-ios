//
//  EditProfileServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EditProfileServiceImpl: BaseServiceImpl, EditProfileService {
    
    func getProfileData() -> Observable<ProfileData> {
        let resultSubject = PublishSubject<ProfileData>()
        
        getUserNodeRef(userId: getCurrentUserId()).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? [String : Any] ?? [:]
            let name = value[NAME_CHILD] as? String ?? ""
            let profilePicture = value[PROFILE_PICTURE_CHILD] as? String ?? ""
            let rating = value[RATING_CHILD] as? Double
            resultSubject.onNext(ProfileData(name: name, profilePicture: profilePicture, rating: rating))
        }
        
        return resultSubject
    }
    
    func saveProfileChanges(inputData: EditProfileInputData) -> Observable<Bool> {
        if let picUrl = inputData.profilePicturePath {
            return uploadProfilePicture(profilePicturePath: picUrl)
                .flatMap { [unowned self ] _ in return self.getProfilePictureUrl() }
                .flatMap { [unowned self ] pictureStorageUrl in return self.saveProfilePictureUrl(url: pictureStorageUrl) }
                .flatMap { [unowned self ] _ in return self.saveUserName(name: inputData.name) }
        } else {
            return saveUserName(name: inputData.name)
        }
    }
    
    private func uploadProfilePicture(profilePicturePath: URL) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        getStorageProfilePictureRef(userId: getCurrentUserId()).putFile(from: profilePicturePath, metadata: nil) { (_, _) in
            resultSubject.onNext(true)
        }
        
        return resultSubject
    }
    
    private func getProfilePictureUrl() -> Observable<String> {
        let resultSubject = PublishSubject<String>()
        
        getStorageProfilePictureRef(userId: getCurrentUserId()).downloadURL { (url, _) in
            if let url = url {
                resultSubject.onNext(url.absoluteString)
            }
        }
        
        return resultSubject
    }
    
    private func saveUserName(name: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        getUserNodeRef(userId: getCurrentUserId()).child(NAME_CHILD).setValue(name) { (_, _) in
            return resultSubject.onNext(true)
        }
        
        return resultSubject
    }
    
    private func saveProfilePictureUrl(url: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        getUserNodeRef(userId: getCurrentUserId()).child(PROFILE_PICTURE_CHILD).setValue(url) { (_, _) in
            return resultSubject.onNext(true)
        }
        
        return resultSubject
    }
}
