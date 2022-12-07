//
//  SettingsStoryboard.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import Foundation

struct SettingsStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .settings
    }

    static var settingsViewController: SettingsViewController {
        instantiateVC(type: SettingsViewController.self)
    }
    
    static var activateStikerViewController: ActivateStikerViewController {
        instantiateVC(type: ActivateStikerViewController.self)
    }
    
    static var changePasswordViewController: ChangePasswordViewController {
        instantiateVC(type: ChangePasswordViewController.self)
    }
    
    static var howToUseViewController: HowToUseViewController {
        instantiateVC(type: HowToUseViewController.self)
    }
    
    static var howToUseDetailsViewController: HowToUseDetailsViewController {
        instantiateVC(type: HowToUseDetailsViewController.self)
    }
    
    static var purchasesViewController: PurchasesViewController {
        instantiateVC(type: PurchasesViewController.self)
    }
}
