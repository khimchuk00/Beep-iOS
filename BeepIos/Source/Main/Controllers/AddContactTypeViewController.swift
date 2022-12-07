//
//  AddContactTypeViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

class AddContactTypeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource = [ContactModel]()
    private var filteredDataSource = [ContactModel]()
    private var section: Int!
    private var frameForCell: CGRect!
    private var categoryId: Int!
    
    weak var delegate: MainCollectionViewCellDelegate?
    
    var onDismiss: (() -> Void)?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        getData()
        addSwipe()
        configureViews()
        configureSearchBar()
    }
    
    func configure(section: Int, categoryId: Int, delegate: MainCollectionViewCellDelegate?, frame: CGRect) {
        self.section = section
        self.delegate = delegate
        self.categoryId = categoryId
        frameForCell = frame
    }
    
    // MARK: - Private methods
    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.font = Theme.Fonts.regular(16)
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10, vertical: 0)
        definesPresentationContext = true
        searchBar.sizeToFit()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: MainCollectionViewCell.self)
    }
    
    private func getData() {
        NetworkManager.shared.getContactTypes { data in
            self.dataSource = data.filter { $0.categoryId == self.categoryId}
            self.dataSource.insert(ContactModel(id: data[0].id, name: "Создать новую", icon: "", isActive: data[0].isActive, pattern: data[0].pattern, categoryId: self.categoryId), at: 0)
            self.filteredDataSource = self.dataSource
            self.collectionView.reloadData()
        } failure: { error in
            guard let error = error else { return }
            ToastView.show(text: "Не удалось загрузить данные", in: self)
        }
    }
    
    private func addSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeView))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AddContactTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(cellType: MainCollectionViewCell.self, for: indexPath)
        if indexPath.item == 0 {
            cell.configure(cellModel: dataSource[indexPath.item], type: .create)
        } else {
            cell.configure(cellModel: dataSource[indexPath.item], type: .change)
        }
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frameForCell.width - 112) / 2 * 160 / 131
        let width = (frameForCell.width - 112) / 2
        return CGSize(width: width, height: height)
    }
}

// MARK: - MainCollectionViewCellDelegate
extension AddContactTypeViewController: MainCollectionViewCellDelegate {
    func mainButtonDidTap(cellModel: ContactModel, type: CellType) {
        switch type {
        case .create:
            if UserDefaultsManager.getBool(for: .isPremium) || UserDataManager.shared.profileData.isPremium {
                let vc = MainStoryboard.addTypeViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.onDismiss = {
                    self.dismiss(animated: false)
                    self.onDismiss?()
                }
                present(vc, animated: true)
            } else {
                let vc = SettingsStoryboard.purchasesViewController
                vc.closure = {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isPremium"), object: nil)
                    self.dismiss(animated: true)
                }
                present(vc, animated: true)
            }
        case .change:
            if UserDefaultsManager.getBool(for: .isPremium) || UserDataManager.shared.profileData.isPremium || cellModel.name == "Instagram" || cellModel.name == "Facebook" || cellModel.name == "Telegram" || cellModel.name == "Viber" || cellModel.name == "WhatsApp" {
                let vc = MainStoryboard.editContactTypeViewController
                vc.modalPresentationStyle = .overCurrentContext
                vc.onDismiss = {
                    self.dismiss(animated: false)
                    self.onDismiss?()
                }
                vc.configure(with: cellModel)
                present(vc, animated: true)
            } else {
                let vc = SettingsStoryboard.purchasesViewController
                vc.closure = {
                    self.tabBarController?.selectedIndex = 0
                }
                present(vc, animated: true)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension AddContactTypeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if searchText.isEmpty {
            dataSource = filteredDataSource
        } else if let text = searchBar.text, !text.isEmpty {
            dataSource = dataSource.filter {
                $0.name.contains("Создать") || $0.name.uppercased().contains(text.uppercased())
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            dataSource = dataSource.filter {
                $0.name.contains("Создать") || $0.name.uppercased().contains(text.uppercased())
            }
            collectionView.reloadData()
        }
        view.endEditing(true)
    }
}
