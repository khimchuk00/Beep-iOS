//
//  SettingsFooterView.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 28.11.2021.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func languageChanged()
}

class SettingsFooterView: NibView {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var RUButton: UIButton!
    @IBOutlet weak var UAButton: UIButton!
    @IBOutlet weak var ENButton: UIButton!
    @IBOutlet weak var ITButton: UIButton!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func awakeFromNib() {
        titleLabel.text = "Settings-language-title".localized()
        versionLabel.text = "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        configureButtons()
    }
    
    // MARK: - Actions
    @IBAction func itButtonDidTap() {
        let loc = UserDefaultsManager.getString(for: .localization)
        UserDefaultsManager.saveString("IT ", for: .localization)
        UserDefaultsManager.saveString(loc, for: .IT)
        configureButtons()
    }
    
    @IBAction func enButtonDidTap() {
        let loc = UserDefaultsManager.getString(for: .localization)
        UserDefaultsManager.saveString("EN ", for: .localization)
        UserDefaultsManager.saveString(loc, for: .IT)
        configureButtons()
    }
    
    @IBAction func ruButtonDidTap() {
        let loc = UserDefaultsManager.getString(for: .localization)
        UserDefaultsManager.saveString("RU ", for: .localization)
        UserDefaultsManager.saveString(loc, for: .IT)
        configureButtons()
    }
    
    @IBAction func ukButtonDidTap() {
        let loc = UserDefaultsManager.getString(for: .localization)
        UserDefaultsManager.saveString("UK ", for: .localization)
        UserDefaultsManager.saveString(loc, for: .IT)
        configureButtons()
    }
    
    // MARK: - Private methods
    private func configureButtons() {
        delegate?.languageChanged()
        titleLabel.text = "Settings-language-title".localized()
        RUButton.layer.cornerRadius = RUButton.frame.height / 2
        UAButton.layer.cornerRadius = UAButton.frame.height / 2
        ENButton.layer.cornerRadius = ENButton.frame.height / 2
        ITButton.layer.cornerRadius = ITButton.frame.height / 2
        switch UserDefaultsManager.getString(for: .localization) {
        case "UK ":
            UAButton.backgroundColor = Theme.Colors.mainWhite
            ITButton.backgroundColor = .clear
            ENButton.backgroundColor = .clear
            RUButton.backgroundColor = .clear
        case "IT ":
            UAButton.backgroundColor = .clear
            ITButton.backgroundColor = Theme.Colors.mainWhite
            ENButton.backgroundColor = .clear
            RUButton.backgroundColor = .clear
        case "EN ":
            UAButton.backgroundColor = .clear
            ITButton.backgroundColor = .clear
            ENButton.backgroundColor = Theme.Colors.mainWhite
            RUButton.backgroundColor = .clear
        case "RU ":
            UAButton.backgroundColor = .clear
            ITButton.backgroundColor = .clear
            ENButton.backgroundColor = .clear
            RUButton.backgroundColor = Theme.Colors.mainWhite
        default:
            break
        }
    }
}
