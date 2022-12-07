//
//  String+validations.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import Foundation

extension String {
    func isValidEmailAddress() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [ .link ]
        let linkDetector = try? NSDataDetector( types: types.rawValue )
        let range = NSRange( location: 0, length: self.count )
        let result = linkDetector?.firstMatch( in: self, options: .reportCompletion, range: range )
        let scheme = result?.url?.scheme ?? ""
        return scheme == "mailto" && result?.range.length == self.count
    }

    func isValidPhoneNumber() -> Bool {
        // Only numbers (0-9) and exactly 8 digits long
        let phoneNumberRegEx = "^[0-9]{8}$"
        let predicate = NSPredicate( format: "SELF MATCHES %@", phoneNumberRegEx )
        return predicate.evaluate( with: self )
    }

    func isValidPasscode() -> Bool {
        let phoneNumberRegEx = "^[A-Za-z\\dd$@$!%*?&#]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return predicate.evaluate(with: self)
    }
}
