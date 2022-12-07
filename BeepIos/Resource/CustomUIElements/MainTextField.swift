//
//  MainTextField.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class MainTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 42)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        configureUI()
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func configureUI() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Theme.Colors.textFieldBorderColor.cgColor
        backgroundColor = Theme.Colors.textFieldBgColor
        borderStyle = .none
        clipsToBounds = true
    }
}
