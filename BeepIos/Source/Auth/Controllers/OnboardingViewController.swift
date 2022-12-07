//
//  OnboardingViewController.swift
//  Beep
//
//  Created by Valentyn Khimchuk on 06.11.2021.
//

import UIKit
import CoreMotion

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var enterButton: MainButton!
    @IBOutlet weak var registerButton: MainButton!
    @IBOutlet weak var localizationsButton: MainButton!
    @IBOutlet weak var UAButton: MainButton!
    @IBOutlet weak var ENButton: MainButton!
    @IBOutlet weak var ITButton: MainButton!
    @IBOutlet weak var languagesView: UIView!
    
    private var motion = CMMotionManager()
    private var timer: Timer?
    private var loc: String = "RU "
    private var UK: String = "UK "
    private var IT: String = "IT "
    private var EN: String = "EN "
    
    private var dataSource = [OnboardingCellModel(image: UIImage(named: "onb_first_img")!, title: "Onboarding-first-title", description: ""), OnboardingCellModel(image: UIImage(named: "onboarding_second_img")!, title: "Onboarding-second-title", description: "Onboarding-second-description"), OnboardingCellModel(image: UIImage(named: "onb_third_img")!, title: "Onboarding-third-title", description: "Onboarding-third-description")]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configurePageControll()
        localize()
        qwe {
            print("qwe")
        } qwe: {
            print("qqq")
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaultsManager.saveString(localizationsButton.titleLabel?.text ?? "RU ", for: .localization)
        UserDefaultsManager.saveString(ITButton.titleLabel?.text ?? "IT ", for: .IT)
        UserDefaultsManager.saveString(ENButton.titleLabel?.text ?? "EN ", for: .EN)
        UserDefaultsManager.saveString(UAButton.titleLabel?.text ?? "UK ", for: .UA)
    }
    
    func showToast() {
        ToastView.show(text: "Профиль удален", in: self)
    }

    func qwe(completion: () -> Void, qwe: () -> Void) {
        completion()
        qwe()
    }

    // MARK: - Actions
    
    @IBAction func localizationsButtonDidTap() {
        
//        "merchantAccount": "test_merch_n1",
//        "merchantDomainName": "www.market.ua",
//        "merchantTransactionSecureType": "AUTO",
//        "merchantSignature": "test_merch_n1;www.market.ua;AUTO;BP1234567155353;1415379863;15;UAH;testproduct;15;1".hmac(algorithm: .MD5, key: "flk3409refn54t54t*FNJRET"),
//        "orderReference": "BP1234567155353",
//        "orderDate": "1415379863",
//        "amount": 15,
//        "currency": "UAH",
//        "productName[]": "testproduct",
//        "productPrice[]": 15,
//        "productCount[]": 1
        
//        NetworkManager.shared.getPaymentURL(merchantSignature: "test_merchant;www.market.ua;BP1234567155353;1415379863;15;UAH;testproduct;15;1".hmac(algorithm: .MD5, key: "flk3409refn54t54t*FNJRET")) { data in
//            print(data)
//        } failure: { err in
//            print(err)
//        }

        languagesView.isHidden.toggle()
    }
    
    @IBAction func UAButtonDidTap() {
//        NetworkManager.shared.getPaymentStatus { data in
//            print(data)
//        } failure: { err in
//            print(err)
//        }

//        let title = localizationsButton.titleLabel?.text
//        localizationsButton.setTitle(UAButton.titleLabel?.text, for: .normal)
//        UAButton.setTitle(title, for: .normal)
//        loc = UAButton.titleLabel?.text ?? "UK "
//        UK = title ?? "RU "
//        languagesView.isHidden = true
//        makeLocalize()
    }
    
    @IBAction func ITButtonDidTap() {
        let title = localizationsButton.titleLabel?.text
        localizationsButton.setTitle(ITButton.titleLabel?.text, for: .normal)
        ITButton.setTitle(title, for: .normal)
        loc = ITButton.titleLabel?.text ?? "IT "
        IT = title ?? "RU "
        languagesView.isHidden = true
        makeLocalize()
    }
    
    @IBAction func ENButtonDidTap() {
        let title = localizationsButton.titleLabel?.text
        localizationsButton.setTitle(ENButton.titleLabel?.text, for: .normal)
        ENButton.setTitle(title, for: .normal)
        loc = ENButton.titleLabel?.text ?? "EN "
        EN = title ?? "RU "
        languagesView.isHidden = true
        makeLocalize()
    }
    
    @IBAction func enterButtonDidTap() {
        let vc = AuthStoryboard.loginViewController
        present(vc, animated: true)
    }
    
    @IBAction func registerButtonDidTap() {
        let vc = AuthStoryboard.registerViewController
        present(vc, animated: true)
    }
    
    // MARK: - Private methods
    private func localize() {
        localizationsButton.setTitle(UserDefaultsManager.getString(for: .localization), for: .normal)
        UAButton.setTitle(UserDefaultsManager.getString(for: .UA), for: .normal)
        ENButton.setTitle(UserDefaultsManager.getString(for: .EN), for: .normal)
        ITButton.setTitle(UserDefaultsManager.getString(for: .IT), for: .normal)
        enterButton.setTitle("Onboarding-enter".localized(), for: .normal)
        registerButton.setTitle("Onboarding-register".localized(), for: .normal)
        collectionView.reloadData()
    }
    
    private func makeLocalize() {
        UserDefaultsManager.saveString(loc, for: .localization)
        UserDefaultsManager.saveString(IT, for: .IT)
        UserDefaultsManager.saveString(EN, for: .EN)
        UserDefaultsManager.saveString(UK, for: .UA)
        enterButton.setTitle("Onboarding-enter".localized(), for: .normal)
        registerButton.setTitle("Onboarding-register".localized(), for: .normal)
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.register(cellType: OnboardingCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configurePageControll() {
        pageControll.numberOfPages = dataSource.count
        pageControll.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
        pageControll.pageIndicatorTintColor = Theme.Colors.pageControllUnselectedColor
        pageControll.currentPageIndicatorTintColor = Theme.Colors.pageControllTintColor
        if #available(iOS 14.0, *) {
            pageControll.backgroundStyle = .minimal
        } else {
            pageControll.backgroundColor = .clear
        }
    }
    
    @objc private func pageControlHandle() {
        let indexPath = IndexPath(item: pageControll.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(cellType: OnboardingCell.self, for: indexPath)
        cell.configure(cellModel: dataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            pageControll.currentPage = indexPath?.item ?? 0
        }
    }
}
