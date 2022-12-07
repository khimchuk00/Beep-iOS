//
//  CodeViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 03.02.2022.
//

import UIKit

class CodeViewController: OffsetableViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var codeTextField: MainTextField!
    @IBOutlet weak var checkEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var checkPasswordLabel: UILabel!
    @IBOutlet weak var checkPasswordTextField: MainTextField!
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
        [codeTextField, passwordTextField, checkPasswordTextField]
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction func continueButtonDidTap() {
        guard let code = codeTextField.text, !code.isEmpty, let password = passwordTextField.text, password.isValidPasscode(), let reapetedPassword = passwordTextField.text, reapetedPassword.isValidPasscode(), reapetedPassword == password else {
            ToastView.show(text: "Проверьте все поля", in: self)
            return }
        
        let vc = AuthStoryboard.usernameViewController
        present(vc, animated: true)
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func configureTextFields() {
        codeTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
}

// MARK: - UITextFieldDelegate
extension CodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
