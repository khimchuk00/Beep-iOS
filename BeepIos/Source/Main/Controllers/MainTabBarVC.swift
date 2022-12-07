//
//  MainTabBarVC.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 24/11/21.
//

import UIKit

class MainTabBarVC: UITabBarController {
    private let main = MainStoryboard.mainViewController
    private let code = QrCodeStoryboard.qrCodeViewController
    private let settings = SettingsStoryboard.settingsViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initVCS()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initVCS()
    }
    
    private func initVCS() {
        delegate = self
        setViewControllers([main, code, settings], animated: false)
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == code {
            tabBar.backgroundColor = .white
        } else {
            tabBar.backgroundColor = Theme.Colors.mainWhite
        }
    }
}
