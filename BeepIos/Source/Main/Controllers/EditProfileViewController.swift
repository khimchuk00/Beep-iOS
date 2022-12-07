//
//  EditProfileViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 20.11.2021.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func dataUpdated(profileData: ProfileModelImage)
}

class EditProfileViewController: OffsetableViewController {
    private enum PickerSender {
        case profile
        case main
    }
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var editBackgroundImageButton: UIButton!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: MainTextField!
    @IBOutlet weak var fioLabel: UILabel!
    @IBOutlet weak var fioTextField: MainTextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextField: MainTextField!
    @IBOutlet weak var saveButton: MainButton!
    @IBOutlet weak var backgroundImageHeight: NSLayoutConstraint!
    
    private var mainImagePicker: UIImagePickerController!
    private var profileImagePicker: UIImagePickerController!
    private var profileData: ProfileModelImage!
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureViews()
        configureImageView()
        configureButtons()
        addSwipe()
        configureTextFields()
        hideKeyboardWhenTappedAround()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        [nameTextField, descriptionTextField]
    }
    
    func configure(profileData: ProfileModelImage, delegate: EditProfileViewControllerDelegate?) {
        self.profileData = profileData
        self.delegate = delegate
    }
    
    // MARK: - Actions
    @IBAction func saveButtonDidTap() {
        profileData.name = nameTextField.text ?? ""
        profileData.fio = fioTextField.text ?? ""
        profileData.about = descriptionLabel.text ?? ""
       
        if let name = nameTextField.text, !name.isEmpty, let fio = fioTextField.text, !fio.isEmpty {
            self.delegate?.dataUpdated(profileData: self.profileData)
            NetworkManager.shared.updateMainImage(imageData: profileData.avatar2.jpegData(compressionQuality: 1) ?? Data())
            NetworkManager.shared.updateProfileData(updateProfileModel: UpdateProfileModel(firstName: name, lastName: fio, about: profileData.about, updateImage: false), image: profileData.avatar.jpegData(compressionQuality: 1) ?? Data(), updateImage: "true") {
                self.dismiss(animated: true)
            } failure: { error in
                guard let error = error else { return }
                ToastView.show(text: "Не удалось обновить данные", in: self)
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func editImageButtonDidTap() {
        changeProfileImage(sender: .profile)
    }
    
    @IBAction func editBGImageButtonDidTap() {
        changeProfileImage(sender: .main)
    }
    
    // MARK: - Private methods
    private func localize() {
        guard profileData != nil else { return }
        nameLabel.text = profileData.name + " " + profileData.fio
        nameTextField.text = profileData.name
        fioTextField.text = profileData.fio
        descriptionLabel.text = profileData.about
        descriptionTextField.text = profileData.about
        nameTitleLabel.text = "Имя"
        nameTextField.placeholder = "Romario"
        fioLabel.text = "Фамилия"
        fioTextField.placeholder = "Korzun"
        descriptionTitleLabel.text = "О себе"
        descriptionTextField.placeholder = "Traveler, blogger"
        
        saveButton.setTitle("Сохранить", for: .normal)
    }
    
    private func configureTextFields() {
        nameTextField.delegate = self
        fioTextField.delegate = self
        descriptionTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        fioTextField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(descTextFieldDidChange), for: .editingChanged)
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height / 2 - 17
        addSecondShadow(to: imageContainerView)
    }
    
    private func configureImageView() {
        backgroundImageHeight.constant = -imageContainerView.frame.height / 2 + 20
        backgroundImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        backgroundImageView.layer.cornerRadius = 20
        imageView.layer.cornerRadius = imageView.frame.width / 2 - 15
        backgroundImageView.image = profileData.avatar2
        imageView.image = profileData.avatar
    }
    
    private func configureButtons() {
        editImageButton.layer.cornerRadius = editImageButton.frame.height / 2
        editBackgroundImageButton.layer.cornerRadius = editBackgroundImageButton.frame.height / 2
        editBackgroundImageButton.setImage(UIImage(named: "camera_img")!.withTintColor(Theme.Colors.mainBlue), for: .normal)
        editBackgroundImageButton.backgroundColor = .white
        editImageButton.setImage(UIImage(named: "camera_img")!.withTintColor(Theme.Colors.mainBlue), for: .normal)
        editImageButton.backgroundColor = .white
    }
    
    private func addSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func takePhoto(from type: UIImagePickerController.SourceType, sender: PickerSender) {
        switch sender {
        case .profile:
            profileImagePicker = UIImagePickerController()
            profileImagePicker.delegate = self
            profileImagePicker.sourceType = type
            present(profileImagePicker, animated: true)
        case .main:
            mainImagePicker = UIImagePickerController()
            mainImagePicker.delegate = self
            mainImagePicker.sourceType = type
            present(mainImagePicker, animated: true)
        }
    }
    
    private func changeProfileImage(sender: PickerSender) {
        let optionMenu = UIAlertController(title: nil, message: "Take photo from:", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "Library", style: .default, handler: { _ in
            self.takePhoto(from: .photoLibrary, sender: sender)
        })
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.takePhoto(from: .camera, sender: sender)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        [library, camera, cancel].forEach {optionMenu.addAction($0)}
        present(optionMenu, animated: true)
    }
    
    private func addSecondShadow(to view: UIView) {
        addShadow(to: view)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
        view.backgroundColor = Theme.Colors.qrCodeBgColor
        view.layer.masksToBounds = false
    }
    
    @objc private func nameTextFieldDidChange() {
        nameLabel.text = (nameTextField.text ?? "") + " " + (fioTextField.text ?? " ")
    }
    
    @objc private func descTextFieldDidChange() {
        descriptionLabel.text = descriptionTextField.text
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if picker === mainImagePicker {
            mainImagePicker.dismiss(animated: true)
            if let selectedImage = info[.originalImage] as? UIImage {
                backgroundImageView.image = selectedImage
                profileData.avatar2 = selectedImage
            }
        } else {
            profileImagePicker.dismiss(animated: true)
            if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
                profileData.avatar = selectedImage
            }
        }
    }
}
