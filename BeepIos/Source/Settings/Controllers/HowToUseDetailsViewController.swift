//
//  HowToUseDetailsViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

class HowToUseDetailsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var escapeLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    private var model: HowToUseDetailsModel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        localize()
    }
    
    func configure(model: HowToUseDetailsModel) {
        self.model = model
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    private func localize() {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        firstLabel.text = model.firstText
        mainImageView.image = model.image
        importantLabel.text = model.imortantText
        secondLabel.text = model.secondText
        escapeLabel.text = model.escapeText
        thirdLabel.text = model.thirdText
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
}
