//
//  Storyboard.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import UIKit

enum Storyboard {
    case auth
    case qrCode
    case settings
    case main
    case splash
    
    var name: String {
        switch self {
        case .auth:
            return "Auth"
        case .qrCode:
            return "QrCode"
        case .settings:
            return "Settings"
        case .main:
            return "Main"
        case .splash:
            return "Splash"
        }
    }
    
    func getStoryboard() -> UIStoryboard {
        UIStoryboard(name: name, bundle: nil)
    }
}

protocol StoryboardInstantiable {
    static var storyboard: Storyboard { get }
}

extension StoryboardInstantiable {
    static func instantiateInitialVC() -> UIViewController {
        if let vc = storyboard.getStoryboard().instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            return vc
        } else {
            fatalError("Storyboard \(storyboard.name) doesn't contain initial View Controller")
        }
    }
    
    static func instantiateInitialVC<T: UIViewController>() -> T {
        if let vc = instantiateInitialVC() as? T {
            vc.modalPresentationStyle = .fullScreen
            return vc
        } else {
            fatalError("Initital ViewController from \(storyboard.name) storyboard doesn't fit type \(T.self)")
        }
    }
    
    static func instantiateVC<T: UIViewController>(type: T.Type, with identifier: String? = nil) -> T {
        let identifier = identifier ?? T.controllerIdentifier
        if let vc = storyboard.getStoryboard().instantiateViewController(withIdentifier: identifier) as? T {
            vc.modalPresentationStyle = .fullScreen
            return vc
        } else {
            fatalError("Storyboard \(storyboard.name) doesn't contain \(T.self) with identifier \(identifier)")
        }
    }
}
