//
//  HowToUseCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

class HowToUseCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    func configure(cellType: HowToUseCellType) {
        titleLabel.text = cellType.title
        descriptionLabel.text = cellType.description
        mainImageView.image = cellType.image
        stackView.layer.cornerRadius = 5
    }
}
