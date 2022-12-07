//
//  PlanCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class PlanCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(type: SettingsCellType, description: String) {
        cellImageView.image = type.image
        titleLabel.text = type.title
        descriptionLabel.text = description
    }
}
