//
//  UsernameViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit
import SafariServices

class UsernameViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: MainTextField!
    @IBOutlet weak var usernameCheckImageView: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var usagesLabel:UILabel!
    @IBOutlet weak var usagesSwitch: UISwitch!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var continueButton: MainButton!
    
    private var registerModel: RegisterModel!
    private var text: String? = "Please agree for Terms & Conditions."
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTextFields()
        configureContainerView()
        configureSwitch()
        configureImageView()
        configureLabels()
        hideKeyboardWhenTappedAround()
    }
    
    func configure(registerModel: RegisterModel) {
        self.registerModel = registerModel
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    @IBAction func continueButtonDidTap() {
        if usagesSwitch.isOn {
            guard let username = usernameTextField.text, !username.isEmpty else { return }
           
            registerModel.userName = username
            NetworkManager.shared.register(registerModel: registerModel) { data in
                if data.statusCode != nil, data.statusCode != 200 {
                    ToastView.show(text: data.message ?? "Регистрация не удалась", in: self)
                } else {
                    UserDefaultsManager.saveString(username, for: .userName)
                    UserDefaultsManager.saveString("https://new.beep.in.ua/" + username, for: .fullLink)
                    self.login(email: data.email, password: data.password ?? "")
                }
            } failure: { error in
                guard let error = error else { return }
                ToastView.show(text: "Регистрация не удалась", in: self)
            }
        } else {
            ToastView.show(text: "Приймите пользовательское соглашение", in: self)
        }
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func login(email: String, password: String) {
        NetworkManager.shared.madeLogin(login: email, password: password) { data in
            if let accessToken = data.accessToken {
                print("accessToken", accessToken)
                UserDefaultsManager.saveString(accessToken, for: .accessToken)
                UserDefaultsManager.saveBool(true, for: .isLoginned)
                let vc = MainStoryboard.mainTabBarVC
                self.present(vc, animated: true)
            } else {
                let vc = AuthStoryboard.loginViewController
                self.present(vc, animated: true)
            }
        } failure: { _ in }
    }
    
    private func configureTextFields() {
        usernameTextField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
    private func configureSwitch() {
        usagesSwitch.onTintColor = Theme.Colors.mainBlue
    }
    
    private func configureImageView() {
        usernameCheckImageView.layer.cornerRadius = usernameCheckImageView.frame.width / 2
    }
    
    private func configureLabels() {
        let string = NSMutableAttributedString(string: "Продолжая, Вы подтверждаете, что прочли, приняли и согласились с нашими ", attributes: [.foregroundColor: UIColor.black])
        let yslovia = NSAttributedString(string: "Условиями использования", attributes: [
            .foregroundColor: Theme.Colors.lightBlue,
            .underlineStyle: 1])
        string.append(yslovia)
        string.append(NSAttributedString(string: " и ", attributes: [.foregroundColor: UIColor.black]))
        let confident = NSAttributedString(string: "Политикой конфиденциальности.", attributes: [
            .foregroundColor: Theme.Colors.lightBlue,
            .underlineStyle: 1])
        string.append(confident)
        confirmationLabel.attributedText = string
        configureLinkLabel(with: "{example}")
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:)))
//        linkLabel.addGestureRecognizer(tapGestureRecognizer)
//        linkLabel.isUserInteractionEnabled = true
//        text = titleLabel.text
//
        linkLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        linkLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = linkLabel.text else { return }
        let numberRange = (text as NSString).range(of: "Условиями использования")
        let emailRange = (text as NSString).range(of: "Политикой конфиденциальности.")
        if gesture.didTapAttributedTextInLabel(label: self.linkLabel, inRange: numberRange) {
            guard let url = URL(string: "https://drive.google.com/drive/folders/1NB-bS4OeoYCbp15_dYjgWugmsSuWM4vn?usp=sharing") else { return }
            let viewController = SFSafariViewController(url: url)
            viewController.modalPresentationStyle = .popover
            present(viewController, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: self.linkLabel, inRange: emailRange) {
            guard let url = URL(string: "https://drive.google.com/drive/folders/1va3jok6pBxksqfo1OF13ViZlbKF08lnZ?usp=sharing") else { return }
            let viewController = SFSafariViewController(url: url)
            viewController.modalPresentationStyle = .popover
            present(viewController, animated: true)
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text! as NSString).range(of: "Условиями использования")
        // comment for now
        let privacyRange = (text! as NSString).range(of: "Политикой конфиденциальности.")
        
        if gesture.didTapAttributedTextInLabel(label: linkLabel, inRange: termsRange) {
            guard let url = URL(string: "https://drive.google.com/drive/folders/1NB-bS4OeoYCbp15_dYjgWugmsSuWM4vn?usp=sharing") else { return }
            let viewController = SFSafariViewController(url: url)
            viewController.modalPresentationStyle = .popover
            present(viewController, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: linkLabel, inRange: privacyRange) {
            guard let url = URL(string: "https://drive.google.com/drive/folders/1va3jok6pBxksqfo1OF13ViZlbKF08lnZ?usp=sharing") else { return }
            let viewController = SFSafariViewController(url: url)
            viewController.modalPresentationStyle = .popover
            present(viewController, animated: true)
        
            print("Tapped privacy")
        } else {
            print("Tapped none")
        }
    }
    
    @objc private func openURL() {
        guard let url = URL(string: UserDefaultsManager.getString(for: .fullLink)) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .popover
        present(viewController, animated: true)
    }
    
    private func configureLinkLabel(with text: String, color: UIColor = Theme.Colors.lightBlue) {
        let string = NSMutableAttributedString(string: "Моя ссылка:  ", attributes: [.foregroundColor: UIColor.black,
                                                                                     .font: Theme.Fonts.bold(14)])
        string.append(NSAttributedString(string: "beep.in.ua/", attributes: [.foregroundColor: UIColor.black,
                                                                             .font: Theme.Fonts.light(14)]))
        string.append(NSAttributedString(string: text, attributes: [.foregroundColor: color,
                                                                    .font: Theme.Fonts.light(14)]))
        linkLabel.attributedText = string
    }
    
    private func checkName(name: String) {
        NetworkManager.shared.checkExistingUserName(name: name) { data in
            self.usernameCheckImageView.isHidden = false
            if data {
                self.configureLinkLabel(with: name, color: Theme.Colors.mainRed)
                self.usernameCheckImageView.image = UIImage(named: "red_close_img")!
            } else {
                self.usernameCheckImageView.image = UIImage(named: "check_img")
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let text = usernameTextField.text, !text.isEmpty else {
            usernameCheckImageView.isHidden = true
            return }
        configureLinkLabel(with: text)
        checkName(name: text)
    }
}

// MARK: - UITextFieldDelegate
extension UsernameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            usernameCheckImageView.isHidden = true
            textField.resignFirstResponder()
            return true }
        configureLinkLabel(with: text)
        checkName(name: text)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            usernameCheckImageView.isHidden = true
            textField.resignFirstResponder()
            return }
        configureLinkLabel(with: text)
        checkName(name: text)
        textField.resignFirstResponder()
    }
}


extension UITapGestureRecognizer {
   
   func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
       guard let attributedText = label.attributedText else { return false }

       let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
       mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
       
       // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
       let paragraphStyle = NSMutableParagraphStyle()
       paragraphStyle.alignment = .center
       mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

       // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
       let layoutManager = NSLayoutManager()
       let textContainer = NSTextContainer(size: CGSize.zero)
       let textStorage = NSTextStorage(attributedString: mutableStr)
       
       // Configure layoutManager and textStorage
       layoutManager.addTextContainer(textContainer)
       textStorage.addLayoutManager(layoutManager)
       
       // Configure textContainer
       textContainer.lineFragmentPadding = 0.0
       textContainer.lineBreakMode = label.lineBreakMode
       textContainer.maximumNumberOfLines = label.numberOfLines
       let labelSize = label.bounds.size
       textContainer.size = labelSize
       
       // Find the tapped character location and compare it to the specified range
       let locationOfTouchInLabel = self.location(in: label)
       let textBoundingBox = layoutManager.usedRect(for: textContainer)
       let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                         y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
       let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                    y: locationOfTouchInLabel.y - textContainerOffset.y);
       let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
       return NSLocationInRange(indexOfCharacter, targetRange)
   }
   
}
