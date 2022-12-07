//
//  OnboardingCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Life cycle
    func configure(cellModel: OnboardingCellModel) {
        mainImageView.image = cellModel.image
        titleLabel.text = cellModel.title.localized()
        descriptionLabel.text = cellModel.description.localized()
        
        mainImageView.layer.cornerRadius = 35
    }
}
