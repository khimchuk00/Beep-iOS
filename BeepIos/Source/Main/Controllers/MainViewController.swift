//
//  MainViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 18.11.2021.
//

import UIKit
import SafariServices
import Alamofire

class MainViewController: UIViewController {    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    private var tableHeaderView = MainTableViewHeader.loadViewFromNib() as! MainTableViewHeader
    
    private var hiddenSections = Set<Int>()
    private var categoriesList = [CategoriesModel]()
    private var profileData: ProfileModelImage?
    private var sortedCountriesList = [[MainTableRow: [ContModel]]]()
    private var dataSource = [Contacts]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableHeaderView.updatePro()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureTableView()
        getProfileData()
        getSubscriptions()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeader), name: NSNotification.Name(rawValue: "isPremium"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "languageChanged"), object: nil)
    }
    
    // MARK: - Private methods
    @objc private func reloadTableView() {
        tableView.reloadData()
    }
    
    private func localize() {
        tabBarController?.tabBar.items?[0].title = "TabBar-card-title".localized()
        tabBarController?.tabBar.items?[1].title = "TabBar-code-title".localized()
        tabBarController?.tabBar.items?[2].title = "TabBar-settings-title".localized()
    }
    
    private func configureTableView() {
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.width * 2.8 / 5) + 165)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: MainTableViewCell.self)
        tableView.tableHeaderView = tableHeaderView
    }
    
    private func getProfileData() {
        getDataSource { profileData in
            guard let profileData = profileData else { return }
            var profileImage: UIImage?
            var mainImage: UIImage?
            self.tableHeaderView.configure(mainImage: UIImage(named: "template_img")!, profileImage: UIImage(), name: profileData.firstName, description: profileData.about ?? "", fio: profileData.lastName, delegate: self)
            self.configureTableView()
            UserDefaultsManager.saveString(profileData.profilePath, for: .userName)
            UserDefaultsManager.saveString("https://new.beep.in.ua/\(profileData.profilePath)", for: .fullLink)
            guard let mainImageUrl = URL(string: "https://server.beep.in.ua/uploads/users/\(profileData.avatar2)"), let profileImageUrl = URL(string: "https://server.beep.in.ua/uploads/users/\(profileData.avatar)") else { return }
            self.downloadImage(from: profileImageUrl) { image in
                self.tableHeaderView.udpateImage(sender: .profile, image: image)
                profileImage = image
                self.downloadImage(from: mainImageUrl) { image in
                    self.tableHeaderView.udpateImage(sender: .main, image: image)
                    mainImage = image
                    self.profileData = ProfileModelImage(name: profileData.firstName, fio: profileData.lastName, about: profileData.about ?? "", avatar: profileImage ?? UIImage(named: "template_img")!, avatar2: mainImage ?? UIImage(), themeId: profileData.themeId ?? 1)
                    UserDataManager.shared.updateProfileData = UpdateProfileModel(firstName: profileData.firstName, lastName: profileData.firstName, about: profileData.about ?? "", updateImage: false, themeId: profileData.themeId)
                }
            }
        }
    }
    
    private func getSubscriptions() {
        NetworkManager.shared.getSubscriptions { data in
            if let isPremium = data.first(where: { $0.user.userName == UserDefaultsManager.getString(for: .userName) }) {
                UserDefaultsManager.saveBool(true, for: .isPremium)
                UserDefaultsManager.saveInt(isPremium.planId, for: .planId)
            } else {
                UserDefaultsManager.saveBool(false, for: .isPremium)
            }
            self.tableHeaderView.updatePro()
        } failure: { err in
            ToastView.show(text: "Не удалось загрузить подписку", in: self)
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data) ?? UIImage())
            }
        }
    }
    
    @objc private func updateHeader() {
        tableHeaderView.updatePro()
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func getCountriesList() {
        for index in 0..<dataSource.count {
            sortedCountriesList.append(transformData(from: dataSource[index].contacts))
        }
    }
    
    private func transformData(from array: [ContModel]) -> [MainTableRow: [ContModel]] {
        var transformedArray = array
        transformedArray.insert(ContModel(id: 1, title: "Создать новую", value: "", isActive: true, pattern: "", contactTypeId: 1, contactTypeName: "", contactTypeIcon: "", contactTypeCategoryName: "", contactTypeCategoryId: 1), at: 0)
        var dataSource: [MainTableRow: [ContModel]] = [:]
        let count = transformedArray.count
        var half = count / 2
        if count % 2 != 0 {
            half += 1
        }
        dataSource[.first] = Array(transformedArray[0 ..< half])
        dataSource[.second] = Array(transformedArray[half ..< count])
        return dataSource
    }
    
    private func getDataSource(completion: ((_ data: ProfileModel?) -> Void)? = nil) {
        NetworkManager.shared.getProfileData { profileData in
            UserDataManager.shared.profileData = profileData
            NetworkManager.shared.getCategoriesList { categoryList in
                self.categoriesList = categoryList
                self.dataSource = profileData.contacts + categoryList.filter { category in
                    !profileData.contacts.contains { $0.category == category.name }
                }.map { Contacts(category: $0.name) }
                for index in 0..<categoryList.count {
                    self.hiddenSections.insert(index)
                }
                self.getCountriesList()
                self.tableView.reloadData()
                completion?(profileData)
            } failure: { error in
                completion?(nil)
                guard let error = error else { return }
                ToastView.show(text: "Не удалось загрузить данные", in: self)
            }
        } failure: { error in
            completion?(nil)
            guard let error = error else { return }
            ToastView.show(text: "Не удалось загрузить данные", in: self)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hiddenSections.contains(section) {
            return 0
        } else {
            return sortedCountriesList[section][.first]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(cellType: MainTableViewCell.self)
        var secontItem: ItemCellModel? = nil
        if indexPath.row < (sortedCountriesList[indexPath.section][.second]?.count ?? 0) {
            if let cont = sortedCountriesList[indexPath.section][.second]?[indexPath.row] {
                secontItem = ItemCellModel(contactModel: cont, type: .change)
            }
        }
        if indexPath.row == 0 {
            cell.configure(firstItem: ItemCellModel(contactModel: (sortedCountriesList[indexPath.section][.first]?[indexPath.row])!, type: .create), secondItem: secontItem, delegate: self, indexPath: indexPath)
        } else {
            cell.configure(firstItem: ItemCellModel(contactModel: (sortedCountriesList[indexPath.section][.first]?[indexPath.row])!, type: .change), secondItem: secontItem, delegate: self, indexPath: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MainTableViewSectionHeader.loadViewFromNib() as! MainTableViewSectionHeader
        header.configure(title: dataSource[section].category, section: section, delegate: self)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (view.frame.width - 112) / 2 * 160 / 131 + 10
    }
}

// MARK: - MainTableViewHeaderDelegate
extension MainViewController: MainTableViewHeaderDelegate {
    func previewButtonDidTap() {
        guard let url = URL(string: UserDefaultsManager.getString(for: .fullLink)) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: true)
    }
    
    func changeProfileButtonDidTap() {
        guard let profileData = profileData else { return }
        let vc = MainStoryboard.editProfileViewController
        vc.configure(profileData: profileData, delegate: self)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
}

// MARK: - MainTableViewFooterDelegate
extension MainViewController: EditProfileViewControllerDelegate {
    func dataUpdated(profileData: ProfileModelImage) {
        self.profileData = profileData
        self.tableHeaderView.configure(mainImage: profileData.avatar2, profileImage: profileData.avatar, name: profileData.name, description: profileData.about, fio: profileData.fio, delegate: self)
        self.tableHeaderView.updatePro()
    }
}

// MARK: - MainTableViewItemViewDelegate
extension MainViewController: MainTableViewItemViewDelegate {
    func mainButtonDidTap(cellModel: ItemCellModel, indexPath: IndexPath, mainTableRow: MainTableRow) {
        switch cellModel.type {
        case .change:
            let vc = MainStoryboard.editAssetViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.configure(with: cellModel.contactModel, delegate: self)
            present(vc, animated: true)
        case .create:
            let vc = MainStoryboard.addContactTypeViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.configure(section: indexPath.section, categoryId: categoriesList.first { $0.name == dataSource[indexPath.section].category }?.id ?? 0, delegate: nil, frame: view.frame)
            vc.onDismiss = {
                self.sortedCountriesList = [[MainTableRow: [ContModel]]]()
                self.dataSource = [Contacts]()
                self.getDataSource()
            }
            present(vc, animated: true)
        case .none:
            break
        }
    }
}

// MARK: - EditAssetViewControllerDelegate
extension MainViewController: EditAssetViewControllerDelegate {
    func updateCell() {
        sortedCountriesList = [[MainTableRow: [ContModel]]]()
        dataSource = [Contacts]()
        getDataSource()
    }
}

// MARK: - MainTableViewSectionHeaderDelegate
extension MainViewController: MainTableViewSectionHeaderDelegate {
    func mainButtonDidTap(inSection: Int) {
        if hiddenSections.contains(inSection) {
            hiddenSections.remove(inSection)
            tableView.insertRows(at: indexPathsForSection(section: inSection), with: .fade)
            tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: inSection), at: .middle, animated: true)
        } else {
            hiddenSections.insert(inSection)
            tableView.deleteRows(at: indexPathsForSection(section: inSection), with: .fade)
            tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: inSection), at: .middle, animated: false)
        }
    }
    
    func indexPathsForSection(section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for row in 0..<(sortedCountriesList[section][.first]?.count ?? 0) {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        
        return indexPaths
    }
}
