//
//  MainButton.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import UIKit

class MainButton: UIButton {
    enum ButtonStyle: Int {
        case filled = 0
        case ghost = 1
        case blueGhost = 2
        case createMain = 3
    }
    
    @IBInspectable
    var style: Int {
        get {
            return buttonStyle.rawValue
        }
        set(newValue) {
            buttonStyle = ButtonStyle(rawValue: newValue) ?? .filled
        }
    }
    
    var buttonStyle: ButtonStyle = .filled {
        didSet {
            configure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        titleLabel?.font = Theme.Fonts.medium(18)
        switch buttonStyle {
        case .filled:
            layer.borderWidth = 0
            setTitleColor(Theme.Colors.mainWhite, for: .normal)
            backgroundColor = Theme.Colors.mainBlue
        case .ghost:
            layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
            setTitleColor(Theme.Colors.buttonDark, for: .normal)
            layer.borderWidth = 1
            backgroundColor = Theme.Colors.mainWhite
        case .blueGhost:
            layer.cornerRadius = 5
            layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
            setTitleColor(Theme.Colors.mainBlue, for: .normal)
            titleLabel?.font = Theme.Fonts.medium(13)
            layer.borderWidth = 1
            backgroundColor = .clear
        case .createMain:
            layer.borderColor = Theme.Colors.buttonsMainBorderColor.cgColor
            setTitleColor(Theme.Colors.mainBlue, for: .normal)
            titleLabel?.font = Theme.Fonts.medium(13)
            layer.borderWidth = 1
            backgroundColor = .clear
            layer.cornerRadius = 5
        }
    }
}
