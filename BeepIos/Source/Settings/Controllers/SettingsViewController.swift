//
//  SettingsViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var tableFooterView: SettingsFooterView!
    
    private var dataSource: [SettingsCellType] = [.plan, .profile, .theme, .callUs, .separator, .activate, .howToUse, .separator, .delete, .password, .exit]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingsTableView.reloadData()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTableView()
        configureContainerView()
//        configureSegmentedControl()
    }
    
    // MARK: - Private methods
    private func localize() {
        titleLabel.text = UserDefaultsManager.getString(for: .userName) + " 👋🏻"
        segmentedControl.setTitle("Settings-light-mode-title".localized(), forSegmentAt: 0)
        segmentedControl.setTitle("Settings-dark-mode-title".localized(), forSegmentAt: 1)
        settingsTableView.reloadData()
        
        tabBarController?.tabBar.items?[0].title = "TabBar-card-title".localized()
        tabBarController?.tabBar.items?[1].title = "TabBar-code-title".localized()
        tabBarController?.tabBar.items?[2].title = "TabBar-settings-title".localized()
    }
    
    private func configureSegmentedControl() {
        segmentedControl.layer.masksToBounds = true
        segmentedControl.clipsToBounds = true
        segmentedControl.layer.cornerRadius = 20
        segmentedControl.selectedSegmentTintColor = Theme.Colors.lightBlue
        segmentedControl.layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
        segmentedControl.backgroundColor = .white
        segmentedControl.tintColor = .white
        segmentedControl.layer.borderWidth = 1.0
//        segmentedControl.addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([.font: Theme.Fonts.light(13),
                                                 .foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.font: Theme.Fonts.light(13),
                                                 .foregroundColor: Theme.Colors.mainDark], for: .normal)
        segmentedControl.selectedSegmentIndex = UserDefaultsManager.getInt(for: .theme) - 1
    }
    
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
    private func configureTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorStyle = .none
        settingsTableView.register(cellType: PlanCell.self)
        settingsTableView.register(cellType: SettingsCell.self)
        settingsTableView.register(cellType: SeparatorCell.self)
        tableFooterView.delegate = self
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsViewController: SettingsViewControllerDelegate {
    func languageChanged() {
        localize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "languageChanged"), object: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = dataSource[indexPath.row]
        switch cellType {
        case .plan:
            let cell = tableView.cell(cellType: PlanCell.self)
            if UserDefaultsManager.getBool(for: .isPremium) || UserDataManager.shared.profileData.isPremium {
                var desctiption = "Settings-plan-cell-month-description".localized()
                switch UserDefaultsManager.getInt(for: .planId) {
                case 1:
                    desctiption = "Settings-plan-cell-month-description".localized()
                case 2:
                    desctiption = "Settings-plan-cell-half-description".localized()
                case 3:
                    desctiption = "Settings-plan-cell-year-description".localized()
                default:
                    break
                }
                cell.configure(type: cellType, description: desctiption)
                cell.descriptionLabel.textColor = Theme.Colors.mainBlue
            } else {
                cell.configure(type: cellType, description: "Settings-plan-cell-description".localized())
            }
           
            cell.selectionStyle = .none
            return cell
        case .separator:
            let cell = tableView.cell(cellType: SeparatorCell.self)
            cell.selectionStyle = .none
            return cell
        case .theme:
            let cell = tableView.cell(cellType: ThemeCell.self)
            cell.configure(type: cellType)
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.cell(cellType: SettingsCell.self)
            cell.configure(type: cellType)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = dataSource[indexPath.row]
        switch cellType {
        case .plan:
            if UserDefaultsManager.getBool(for: .isPremium) || !UserDataManager.shared.profileData.isPremium {
                
            } else {
                let vc = SettingsStoryboard.purchasesViewController
                vc.closure = {
                    self.tabBarController?.selectedIndex = 0
                }
                present(vc, animated: false)
            }
        case .callUs:
            guard let url = URL(string: "tg://resolve?domain=beepnfc") else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                ToastView.show(text: "Телеграм не установлен", in: self)
            }
        case .profile:
            tabBarController?.selectedIndex = 0
        case .activate:
            let vc = SettingsStoryboard.activateStikerViewController
            present(vc, animated: false)
        case .howToUse:
            let vc = SettingsStoryboard.howToUseViewController
            present(vc, animated: false)
        case .password:
            let vc = SettingsStoryboard.changePasswordViewController
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
        case .delete:
            let alert = UIAlertController(title: "Удалить профиль", message: "Вы действительно хотите удалить профиль?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { _ in
                       //Cancel Action
                   }))
                   alert.addAction(UIAlertAction(title: "Удалить",
                                                 style: .default,
                                                 handler: { _ in
                       self.deleteUser()
                   }))
                   self.present(alert, animated: true, completion: nil)
        case .exit:
            UserDefaultsManager.saveString("", for: .accessToken)
            UserDefaultsManager.saveBool(false, for: .isLoginned)
            let vc = AuthStoryboard.onboardingViewController
            self.present(vc, animated: true)
        default:
            print("default")
        }
    }
    
    @objc private func deleteUser() {
        NetworkManager.shared.deleteProfile {
            let vc = AuthStoryboard.onboardingViewController
            self.present(vc, animated: true) {
                vc.showToast()
            }
        } failure: { error in
            guard let error = error else { return }
            ToastView.show(text: "Не удалось удалить пользователя", in: self)
        }
    }
}

// MARK: - ChangePasswordViewControllerDelegate
extension SettingsViewController: ChangePasswordViewControllerDelegate {
    func passwordWasChanged() {
        ToastView.show(text: "Пароль изменен", in: self)
    }
}
