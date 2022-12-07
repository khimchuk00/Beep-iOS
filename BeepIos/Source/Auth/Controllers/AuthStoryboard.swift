//
//  AuthStoryboard.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import Foundation

struct AuthStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .auth
    }
    
    static var onboardingViewController: OnboardingViewController {
        instantiateVC(type: OnboardingViewController.self)
    }
    
    static var loginViewController: LoginViewController {
        instantiateVC(type: LoginViewController.self)
    }
    
    static var registerViewController: RegisterViewController {
        instantiateVC(type: RegisterViewController.self)
    }
    
    static var usernameViewController: UsernameViewController {
        instantiateVC(type: UsernameViewController.self)
    }
    
    static var forgotPasswordViewController: ForgotPasswordViewController {
        instantiateVC(type: ForgotPasswordViewController.self)
    }
    
    static var codeViewController: CodeViewController {
        instantiateVC(type: CodeViewController.self)
    }
}
