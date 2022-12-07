//
//  MainTableViewCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 18.11.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var firstView: MainTableViewItemView!
    @IBOutlet weak var secondView: MainTableViewItemView!
    
    func configure(firstItem: ItemCellModel, secondItem: ItemCellModel?, delegate: MainTableViewItemViewDelegate?, indexPath: IndexPath) {
        firstView.configure(cellModel: firstItem, indexPath: indexPath, mainTableRow: .first)
        firstView.delegate = delegate
        secondView.isHidden = secondItem == nil
        if let secondItem = secondItem {
            secondView.configure(cellModel: secondItem, indexPath: indexPath, mainTableRow: .second)
            secondView.delegate = delegate
        }
    }
}
