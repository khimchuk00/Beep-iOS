//
//  LoginViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: MainTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var enterWithLabel: UILabel!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var continueButton: MainButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTextFields()
        configureButtons()
        configureContainerView()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction func continueButtonDidTap() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        NetworkManager.shared.madeLogin(login: email, password: password) { data in
            if let accessToken = data.accessToken {
                print("accessToken", accessToken)
                UserDefaultsManager.saveString(accessToken, for: .accessToken)
                UserDefaultsManager.saveBool(true, for: .isLoginned)
                let vc = MainStoryboard.mainTabBarVC
                self.present(vc, animated: true)
            } else {
                ToastView.show(text: "Проверьте пароль", in: self)
            }
        } failure: { error in
            guard let error = error else { return }
            ToastView.show(text: "Проверьте пароль", in: self)
        }
    }
    
    @IBAction func forgotPasswordButtonDidTap() {
        let vc = AuthStoryboard.forgotPasswordViewController
        present(vc, animated: true)
    }
    
    @IBAction func appleButtonDidTap() {
        UserDefaultsManager.saveString("https://new.beep.in.ua/nabilskiy", for: .fullLink)
    }
    
    @IBAction func facebookButtonDidTap() {
        
    }
    
    @IBAction func googleButtonDidTap() {
        
    }
    
    // MARK: - Private methods
    func localize() {
        
    }
    
    func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    }
    
    func configureButtons() {
        appleButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
        googleButton.layer.cornerRadius = 5
    }
    
    func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
