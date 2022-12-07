//
//  UIViewController+Name.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import UIKit

extension UIViewController {
    static var controllerIdentifier: String {
        String(describing: self)
    }
}
