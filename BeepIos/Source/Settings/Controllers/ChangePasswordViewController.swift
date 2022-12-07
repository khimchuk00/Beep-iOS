//
//  ChangePasswordViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 28.11.2021.
//

import UIKit

protocol ChangePasswordViewControllerDelegate: AnyObject {
    func passwordWasChanged()
}
 
class ChangePasswordViewController: OffsetableViewController {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: MainTextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: MainTextField!
    @IBOutlet weak var saveButton: MainButton!
    
    weak var delegate: ChangePasswordViewControllerDelegate?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTextFields()
        configureViews()
        addSwipe()
        setupKeyboardObservers()
    }
    
    override func offsetableTextFields() -> [UITextField] {
        [passwordTextField, repeatPasswordTextField]
    }
    
    // MARK: - Actions
    @IBAction func saveButtonDidTap() {
        if let pass = passwordTextField.text, !pass.isEmpty, let repeatPass = repeatPasswordTextField.text, !repeatPass.isEmpty, pass == repeatPass {
            NetworkManager.shared.changePassword(password: pass, confirmPassword: repeatPass) {
                self.delegate?.passwordWasChanged()
                self.dismiss(animated: true)
            } failure: { error in
                guard let error = error else { return }
                ToastView.show(text: "Пароли не совпадают", in: self)
            }
        } else if let pass = passwordTextField.text, let repeatPass = repeatPasswordTextField.text, pass != repeatPass {
            ToastView.show(text: "Пароли не совпадают", in: self)
        }
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    private func configureTextFields() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
    @objc private func keyboardWillHiden() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardWillShown() {
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - UITextFieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
