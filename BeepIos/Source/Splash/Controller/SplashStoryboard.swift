//
//  SplashStoryboard.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 05.01.2022.
//

import Foundation

struct SplashStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .splash
    }
    
    static var onboardingViewController: OnboardingViewController {
        instantiateVC(type: OnboardingViewController.self)
    }
}
