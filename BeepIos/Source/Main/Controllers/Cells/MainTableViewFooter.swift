//
//  MainTableViewFooter.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 23.11.2021.
//

import UIKit

protocol MainTableViewFooterDelegate: AnyObject {
    func saveButtonDidTap()
}

class MainTableViewFooter: UIView {
    // MARK: - Outlets
    @IBOutlet weak var saveButton: MainButton!
    
    weak var delegate: MainTableViewFooterDelegate?
    
    func configure(title: String, delegate: MainTableViewFooterDelegate?) {
        self.delegate = delegate
        saveButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func saveButtonDidTap() {
        delegate?.saveButtonDidTap()
    }
}
