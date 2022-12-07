//
//  ForgotPasswordViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 03.02.2022.
//

import UIKit

class ForgotPasswordViewController: OffsetableViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: MainTextField!
    @IBOutlet weak var checkEmailLabel: UILabel!
    @IBOutlet weak var continueButton: MainButton!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTextFields()
        configureContainerView()
        hideKeyboardWhenTappedAround()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        [emailTextField]
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction func continueButtonDidTap() {
        guard let email = emailTextField.text, email.isValidEmailAddress() else {
            ToastView.show(text: "Проверьте емейл", in: self)
            return }
        
        NetworkManager.shared.getEmailCode(email: email) { data in
            if data {
                let vc = AuthStoryboard.codeViewController
                self.present(vc, animated: true)
            } else {
                ToastView.show(text: "Не удалось обновить данные", in: self)
            }
        }
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func configureTextFields() {
        emailTextField.delegate = self
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField === emailTextField, let text = textField.text, !text.isValidEmailAddress() {
            checkEmailLabel.isHidden = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === emailTextField, let text = textField.text, !text.isValidEmailAddress() {
            checkEmailLabel.isHidden = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === emailTextField {
            checkEmailLabel.isHidden = true
        }
    }
}
