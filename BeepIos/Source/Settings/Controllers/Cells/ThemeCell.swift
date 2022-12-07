//
//  ThemeCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 03.02.2022.
//

import UIKit

class ThemeCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    func configure(type: SettingsCellType) {
        cellImageView.image = type.image
        titleLabel.text = switcher.isOn ? "Settings-theme-black-cell-title".localized(): "Settings-theme-white-cell-title".localized()
        switcher.isOn = UserDefaultsManager.getBool(for: .switcherIsOn)
        titleLabel.textColor = type.titleColor
    }
    
    @IBAction func valueChanged() {
        if switcher.isOn {
            switcher.tintColor = Theme.Colors.lightBlue
            titleLabel.text = "Settings-theme-black-cell-title".localized()
            UserDataManager.shared.updateProfileData.themeId = 1
            NetworkManager.shared.updateProfileData(updateProfileModel: UserDataManager.shared.updateProfileData, image: Data(), updateImage: "false") {
                UserDefaultsManager.saveInt(1, for: .theme)
            } failure: { _ in
            }
        } else {
            switcher.tintColor = Theme.Colors.mainRed
            titleLabel.text = "Settings-theme-white-cell-title".localized()
            UserDataManager.shared.updateProfileData.themeId = 2
            NetworkManager.shared.updateProfileData(updateProfileModel: UserDataManager.shared.updateProfileData, image: Data(), updateImage: "false") {
                UserDefaultsManager.saveInt(2, for: .theme)
            } failure: { _ in
            }
        }
        UserDefaultsManager.saveBool(switcher.isOn, for: .switcherIsOn)
    }
}
