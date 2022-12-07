//
//  SplashViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 05.01.2022.
//

import UIKit

class SplashViewController: UIViewController {
    // MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = UserDefaultsManager.getBool(for: .isLoginned) && UserDefaultsManager.getString(for: .accessToken) != "" ? MainStoryboard.mainTabBarVC : AuthStoryboard.onboardingViewController
        present(vc, animated: true)
    }
}
