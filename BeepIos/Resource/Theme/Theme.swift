//
//  Theme.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import UIKit

class Theme {
    struct Colors {
        static let mainBlue = UIColor(hex: "#0092D0")!
        static let lightBlue = UIColor(hex: "#00B6FF")!
        static let lightRed = UIColor(hex: "#EA7271")!
        static let lightGrey = UIColor(hex: "#9493A3")!
        static let mainGrey = UIColor(hex: "#606060")!
        static let mainRed = UIColor(hex: "#FF4A45")!
        static let mainDark = UIColor(hex: "#1C1C1C")!
        static let mainWhite = UIColor(hex: "#F4F4F6")!
        static let buttonDark = UIColor(hex: "#1B1B1D")!
        static let mainTitlesDark = UIColor(hex: "#2B2B2B")!
        static let buttonBorderColor = UIColor(hex: "#E2E2E4")!
        static let pageControllTintColor = UIColor(hex: "#0DC5FF")!
        static let pageControllUnselectedColor = UIColor(hex: "#EAEAEC")!
        static let textFieldBorderColor = UIColor(hex: "#E4E5E9")!
        static let textFieldBgColor = UIColor(hex: "#F4F5FA")!
        static let qrCodeBgColor = UIColor(hex: "#FDFDFD")!
        static let separatorColor = UIColor(hex: "#E6E5E5")
        static let buttonsMainBorderColor = UIColor(hex: "#49C9FF")!
    }
    
    enum Fonts {
        static public func regular(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Regular", size: fontSize)!
        }
        
        static public func bold(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Bold", size: fontSize)!
        }
        
        static public func light(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Light", size: fontSize)!
        }
        
        static public func semiBold(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-SemiBold", size: fontSize)!
        }
        
        static public func medium(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Medium", size: fontSize)!
        }
        
        static public func mediumItalic(_ fontSize: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-MediumItalic", size: fontSize)!
        }
    }
}
