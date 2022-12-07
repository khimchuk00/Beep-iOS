//
//  String+localized .swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable_\(UserDefaultsManager.getString(for: .localization))", comment: self)
    }
}
