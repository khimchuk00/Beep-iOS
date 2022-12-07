//
//  MainTableViewSectionHeader.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 23.11.2021.
//

import UIKit

protocol MainTableViewSectionHeaderDelegate: AnyObject {
    func mainButtonDidTap(inSection: Int)
}

class MainTableViewSectionHeader: UIView {
    // MARK: - Outlets
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: MainTableViewSectionHeaderDelegate?
    
    private var section: Int!
    private var isSectionHidden = false
    
    // MARK: - Life cycle
    func configure(title: String, section: Int, delegate: MainTableViewSectionHeaderDelegate?) {
        self.delegate = delegate
        self.section = section
        switch title {
        case "Социальные сети":
            mainButton.setTitle("Dashboard-networks-title".localized(), for: .normal)
        case "Мессенджеры":
            mainButton.setTitle("Dashboard-messgers-title".localized(), for: .normal)
        case "Личные контакты":
            mainButton.setTitle("Dashboard-contacts-title".localized(), for: .normal)
        case "Музыкальные платформы":
            mainButton.setTitle("Dashboard-music-title".localized(), for: .normal)
        case "Видеохостинги":
            mainButton.setTitle("Dashboard-videos-title".localized(), for: .normal)
        case "Денежные переводы":
            mainButton.setTitle("Dashboard-moneys-title".localized(), for: .normal)
        case "Портфолио":
            mainButton.setTitle("Dashboard-portfolio-title".localized(), for: .normal)
        case "Гейминг":
            mainButton.setTitle("Dashboard-games-title".localized(), for: .normal)
        case "Оставить отзыв":
            mainButton.setTitle("Dashboard-review-title".localized(), for: .normal)
        case "Как добраться":
            mainButton.setTitle("Dashboard-getThere-title".localized(), for: .normal)
        default:
            break
        }
        addMainShadow(to: containerView)
    }
    
    // MARK: - Actions
    @IBAction func mainButtonDidTap() {
        delegate?.mainButtonDidTap(inSection: section)
        isSectionHidden.toggle()
        if isSectionHidden {
            mainButton.setTitleColor(Theme.Colors.lightBlue, for: .normal)
        } else {
            mainButton.setTitleColor(Theme.Colors.mainDark, for: .normal)
        }
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
