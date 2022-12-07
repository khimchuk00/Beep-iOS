//
//  SettingsCellType.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

enum SettingsCellType {
    case plan
    case ref
    case profile
    case theme
    case callUs
    case separator
    case activate
    case howToUse
    case delete
    case password
    case exit
    
    var title: String {
        switch self {
        case .plan:
            return "Settings-plan-cell-title".localized()
        case .ref:
            return "Settings-ref-cell-title".localized()
        case .profile:
            return "Settings-profile-cell-title".localized()
        case .theme:
            return "Settings-theme-white-cell-title".localized()
        case .callUs:
            return "Settings-callUs-cell-title".localized()
        case .separator:
            return ""
        case .activate:
            return "Settings-activate-cell-title".localized()
        case .howToUse:
            return "Settings-howToUse-cell-title".localized()
        case .delete:
            return "Settings-delete-cell-title".localized()
        case .password:
            return "Settings-password-cell-title".localized()
        case .exit:
            return "Settings-exit-cell-title".localized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .plan:
            return UIImage(named: "plan_img")!
        case .ref:
            return UIImage(named: "wallet_img")!
        case .profile:
            return UIImage(named: "profile_img")!
        case .theme:
            return UIImage(named: "profile_img")!
        case .callUs:
            return UIImage(named: "call_us_img")!
        case .separator:
            return UIImage(named: "plan_img")!
        case .activate:
            return UIImage(named: "activate_img")!
        case .howToUse:
            return UIImage(named: "how_to_use_img")!
        case .delete:
            return UIImage(named: "trash_img")!
        case .password:
            return UIImage(named: "password_img")!
        case .exit:
            return UIImage(named: "logout_img")!
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .ref:
            return Theme.Colors.lightBlue
        case .exit:
            return Theme.Colors.mainRed
        default:
            return Theme.Colors.mainDark
        }
    }
}
