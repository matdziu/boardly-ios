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

class EditProfileViewController: BaseNavViewController, EditProfileView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameInputField: BoardlyTextField!
    @IBOutlet weak var saveChangesButton: BoardlyButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var initialize = true
    private var selectedProfilePicture: UIImage? = nil
    private var defaultRatingText = "You current rating: "
    private let editProfilePresenter = EditProfilePresenter(
        editProfileInteractor: EditProfileInteractorImpl(editProfileService: EditProfileServiceImpl()))
    private let imagePicker = UIImagePickerController()
    
    private var fetchProfileDataSubject: PublishSubject<Bool>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileImageView()
        imagePicker.delegate = self
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
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.cornerRadius = 3.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImageView.addGestureRecognizer(tap)
    }
    
    func render(editProfileViewState: EditProfileViewState) {
        showProgress(show: editProfileViewState.progress)
        showNameFieldError(show: editProfileViewState.nameFieldEmpty)
        
        if editProfileViewState.render {
            let profileData = editProfileViewState.profileData
            nameInputField.text = profileData.name
            profileImageView.downloaded(from: profileData.profilePictureUrl)
            ratingLabel.text = defaultRatingText + ratingString(rating: profileData.rating)
        }
        
        if editProfileViewState.successfulUpdate {
            if let homeViewController = storyboard?.instantiateViewController(withIdentifier: MAIN_TAB_VIEW_CONTROLLER_ID) as? MainTabViewController {
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
            return String(format: "%.2f", rating!)
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
                name: self.nameInputField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
                profilePicture: self.selectedProfilePicture) })
    }
    
    func fetchProfileDataTriggerEmitter() -> Observable<Bool> {
        return fetchProfileDataSubject
    }
    
    @objc private func selectImage() {
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedProfilePicture = pickedImage
            profileImageView.image = pickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
