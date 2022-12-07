//
//  HowToUseViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

class HowToUseViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabheViewHeight: NSLayoutConstraint!
    
    private var dataSource: [HowToUseCellType] = [.newIPhones, .oldIPhones, .androids, .qrCode]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureContainerView()
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: false)
    }
    
    // MARK: - Private methods
    private func lozalize() {
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellType: HowToUseCell.self)
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HowToUseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(cellType: HowToUseCell.self)
        cell.configure(cellType: dataSource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SettingsStoryboard.howToUseDetailsViewController
        vc.configure(model: dataSource[indexPath.row].detailsModel)
        present(vc, animated: true)
    }
}
