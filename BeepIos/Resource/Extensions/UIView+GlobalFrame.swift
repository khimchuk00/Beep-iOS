//
//  UIView+GlobalFrame.swift
//  EducationApp
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

extension UIView {
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
