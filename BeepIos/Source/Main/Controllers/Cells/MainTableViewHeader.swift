//
//  MainTableViewHeader.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 23.11.2021.
//

import UIKit

protocol MainTableViewHeaderDelegate: AnyObject {
    func previewButtonDidTap()
    func changeProfileButtonDidTap()
}

class MainTableViewHeader: UIView {
    // MARK: - Outlets
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var changeMainImageButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var proViewWidth: NSLayoutConstraint!
    
    weak var delegate: MainTableViewHeaderDelegate?
    
    func configure(mainImage: UIImage, profileImage: UIImage, name: String, description: String, fio: String, delegate: MainTableViewHeaderDelegate?) {
        mainImageView.image = mainImage
        profileImageView.image = profileImage
        nameLabel.text = name + " " + fio
        descriptionLabel.text = description
        self.delegate = delegate
        configureMainImage()
        updatePro()
        addMainShadow(to: proView)
    }
    
    func updatePro() {
        proView.isHidden = !UserDefaultsManager.getBool(for: .isPremium)
        proViewWidth.constant = UserDefaultsManager.getBool(for: .isPremium) ? 40 : 0
    }
    
    func udpateImage(sender: PickerSender, image: UIImage) {
        switch sender {
       case .profile:
           profileImageView.image = image
       case .main:
           mainImageView.image = image
       }
        updatePro()
    }
    
    // MARK: - Actions
    @IBAction func previewButtonDidTap() {
        delegate?.previewButtonDidTap()
    }
    
    @IBAction func changeProfileButtonDidTap() {
        delegate?.changeProfileButtonDidTap()
    }
    
    // MARK: - Private methods
    private func configureMainImage() {
        profileImageView.layer.cornerRadius = 20
    }
    
    private func addMainShadow(to view: UIView) {
        addShadow(to: view)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        view.layer.cornerRadius = 10
    }
    
    private func addShadow(to view: UIView) {
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
        view.backgroundColor = Theme.Colors.qrCodeBgColor
        view.layer.masksToBounds = false
    }
}
