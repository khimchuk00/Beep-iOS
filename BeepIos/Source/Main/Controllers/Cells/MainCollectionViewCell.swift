//
//  MainCollectionViewCell.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

protocol MainCollectionViewCellDelegate: AnyObject {
    func mainButtonDidTap(cellModel: ContactModel, type: CellType)
}

class MainCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainButton: MainButton!
    @IBOutlet weak var proView: UIView!
    
    private var cellModel: ContactModel!
    private var section: Int!
    private var type: CellType!
    
    weak var delegate: MainCollectionViewCellDelegate?
    
    func configure(cellModel: ContactModel, type: CellType) {
        self.type = type
        self.cellModel = cellModel
        titleLabel.text = cellModel.name
        configureUI()
        switch type {
        case .change:
            if let url = URL(string: "https://server.beep.in.ua/uploads/contact_types/\(cellModel.icon ?? "")") {
                downloadImage(from: url, completion: { [cellModel] image in
                    if cellModel.name != "Создать новую", cellModel.name == self.cellModel.name {
                        self.mainImageView.image = image
                    }
                })
            }
            titleLabel.textColor = Theme.Colors.mainDark
            titleLabel.font = Theme.Fonts.medium(15)
            mainButton.setTitle("Добавить", for: .normal)
            mainButton.style = 3
            if cellModel.name == "Instagram" || cellModel.name == "Facebook" || cellModel.name == "Telegram" || cellModel.name == "Viber" || cellModel.name == "WhatsApp" {
                proView.isHidden = true
            } else if UserDefaultsManager.getBool(for: .isPremium) {
                proView.isHidden = true
            } else {
                proView.isHidden = false
            }
            addMainShadow(to: proView)
        case .create:
            proView.isHidden = true
            titleLabel.textColor = Theme.Colors.mainBlue
            titleLabel.font = Theme.Fonts.light(14)
            imageContainerView.layer.borderColor = Theme.Colors.mainBlue.cgColor
            mainButton.setTitle("Создать", for: .normal)
            mainButton.style = 2
            mainImageView.image = UIImage(named: "edit_main_img")!
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonDidTap() {
        delegate?.mainButtonDidTap(cellModel: cellModel, type: type)
    }
    
    // MARK: - Private methods
    private func configureUI() {
        addMainShadow(to: containerView)
        addSecondShadow(to: imageContainerView)
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height / 2
        mainImageView.layer.cornerRadius = mainImageView.frame.height / 2
    }
    
    private func addMainShadow(to view: UIView) {
        addShadow(to: view)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        view.layer.cornerRadius = 10
    }
    
    private func addSecondShadow(to view: UIView) {
        addShadow(to: view)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.02).cgColor
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
    
    private func downloadImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(UIImage(data: data) ?? UIImage())
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
