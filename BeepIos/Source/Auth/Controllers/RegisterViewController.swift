//
//  RegisterViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit
import FlagPhoneNumber

class RegisterViewController: OffsetableViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fioLabel: UILabel!
    @IBOutlet weak var fioTextField: MainTextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: MainTextField!
    @IBOutlet weak var checkFioLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextField: MainTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: MainTextField!
    @IBOutlet weak var checkEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var continueButton: MainButton!
    @IBOutlet weak var flagTextField: FPNTextField!
    
    private var listController = FPNCountryListViewController(style: .grouped)
    private var code = "+380"
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTextFields()
        configureContainerView()
        hideKeyboardWhenTappedAround()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        [emailTextField, passwordTextField]
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction func continueButtonDidTap() {
        guard let fio = fioTextField.text, !fio.isEmpty, let name = nameTextField.text, !name.isEmpty, let number = numberTextField.text, !number.isEmpty, let email = emailTextField.text, email.isValidEmailAddress(), let password = passwordTextField.text, !password.isEmpty, password.isValidPasscode() else {
            ToastView.show(text: "Проверьте все поля", in: self)
            return }
        
        let phone = code + number
        let registerModel = RegisterModel(userTypeId: 1, userName: "", email: email, password: password, firstName: name, lastName: fio, phone: phone, referral: "")
        let vc = AuthStoryboard.usernameViewController
        vc.configure(registerModel: registerModel)
        present(vc, animated: true)
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        numberTextField.delegate = self
        fioTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        flagTextField.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCountries))
        flagTextField.addGestureRecognizer(tapGestureRecognizer)
        flagTextField.hasPhoneNumberExample = false
        flagTextField.placeholder = ""
        flagTextField.setFlag(key: .UA)
        numberTextField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        flagTextField.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        flagTextField.layer.cornerRadius = 10
        flagTextField.layer.borderWidth = 1
        flagTextField.layer.borderColor = Theme.Colors.textFieldBorderColor.cgColor
        flagTextField.backgroundColor = Theme.Colors.textFieldBgColor
        flagTextField.borderStyle = .none
        listController.setup(repository: flagTextField.countryRepository)
        listController.didSelect = { country in
            self.flagTextField.setFlag(countryCode: country.code)
        }
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
    @objc private func showCountries() {
        fpnDisplayCountryList()
    }
}

// MARK: - FPNTextFieldDelegate
extension RegisterViewController: FPNTextFieldDelegate {
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        present(navigationViewController, animated: true)
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.code = dialCode
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {}
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
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
        if textField === fioTextField {
            checkFioLabel.isHidden = true
        }
    }
}
