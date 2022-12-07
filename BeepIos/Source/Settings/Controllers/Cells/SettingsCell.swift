//
//  SettingsCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class SettingsCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(type: SettingsCellType) {
        cellImageView.image = type.image
        titleLabel.text = type.title
        titleLabel.textColor = type.titleColor
    }
}
