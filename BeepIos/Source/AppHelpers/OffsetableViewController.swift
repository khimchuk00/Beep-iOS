//
//  OffsetableViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class OffsetableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    func offsetableTextFields() -> [UITextField] {
        return []
    }
    
    private func offsetValue(forKeyboardHeight keyboardHeight: CGFloat) -> CGFloat {
        guard let textFieldFrame = offsetableTextFields().first(where: { $0.isFirstResponder })?.globalFrame else {
            return 0
        }
        
        let offset: CGFloat = 100 + view.safeAreaInsets.bottom
        if textFieldFrame.minY + textFieldFrame.height + offset > view.frame.height - keyboardHeight {
            return textFieldFrame.minY + textFieldFrame.height + offset + keyboardHeight - view.frame.height
        } else {
            return 0
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offsetHeigh = offsetValue(forKeyboardHeight: keyboardSize.height)
            if self.view.frame.origin.y == 0 && offsetHeigh > 0 {
                self.view.frame.origin.y -= offsetHeigh
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

