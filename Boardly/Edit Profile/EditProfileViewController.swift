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
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
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
        showProgress(show: editProfileViewState.progress)
        showNameFieldError(show: editProfileViewState.nameFieldEmpty)
        
        if editProfileViewState.render {
            let profileData = editProfileViewState.profileData
            nameInputField.text = profileData.name
            ratingLabel.text = ratingLabel.text ?? "" + ratingString(rating: profileData.rating)
        }
        
        if editProfileViewState.successfulUpdate {
            if let homeViewController = storyboard?.instantiateViewController(withIdentifier: HOME_VIEW_CONTROLLER_ID) as? HomeViewController {
                navigationController?.setViewControllers([homeViewController], animated: true)
            }
        }
    }
    
    private func showNameFieldError(show: Bool) {
        nameInputField.showError(show: show)
        if show {
            nameLabel.textColor = UIColor(named: Color.errorRed.rawValue)
        } else {
            nameLabel.textColor = UIColor(named: Color.grey.rawValue)
        }
    }
    
    private func ratingString(rating: Double?) -> String {
        if rating != nil {
            return String(format: "%.2d", rating!)
        } else {
            return "-"
        }
    }
    
    private func showProgress(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    func inputDataEmitter() -> Observable<EditProfileInputData> {
        return saveChangesButton
            .rx
            .controlEvent(UIControlEvents.touchUpInside)
            .map({ [unowned self] in return EditProfileInputData(
                name: self.nameInputField.text ?? "",
                profilePicturePath: self.selectedProfilePicturePath) })
    }
    
    func fetchProfileDataTriggerEmitter() -> Observable<Bool> {
        return fetchProfileDataSubject
    }
}
