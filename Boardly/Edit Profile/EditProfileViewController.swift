//
//  EditProfileViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseNavViewController, EditProfileView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameInputField: BoardlyTextField!
    @IBOutlet weak var saveChangesButton: BoardlyButton!
    
    private var initialize = true
    private var selectedProfilePicturePath: URL? = nil
    private let editProfilePresenter = EditProfilePresenter(
        editProfileInteractor: EditProfileInteractorImpl(editProfileService: EditProfileServiceImpl()))
    
    private var fetchProfileDataSubject: PublishSubject<Bool>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        editProfilePresenter.bind(editProfileView: self)
        fetchProfileDataSubject.onNext(initialize)
    }
    
    private func initEmitters() {
        fetchProfileDataSubject = PublishSubject<Bool>()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        editProfilePresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    private func initProfileImageView() {
        profileImageView.layer.borderColor = UIColor(named: Color.grey.rawValue)?.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = 3.0
    }
    
    func render(editProfileViewState: EditProfileViewState) {
        
    }
    
    func inputDataEmitter() -> Observable<EditProfileInputData> {
        return saveChangesButton
            .rx
            .controlEvent(UIControlEvents.touchUpInside)
            .map({ [unowned self] in return EditProfileInputData(
                name: self.nameInputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                profilePicturePath: self.selectedProfilePicturePath) })
    }
    
    func fetchProfileDataTriggerEmitter() -> Observable<Bool> {
        return fetchProfileDataSubject
    }
}
