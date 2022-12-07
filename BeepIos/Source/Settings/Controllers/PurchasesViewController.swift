//
//  PurchasesViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 30.11.2021.
//

import UIKit

class PurchasesViewController: UIViewController {
    enum Subscriptions: String {
        case oneMonth = "One month"
        case halfYear = "Half year"
        case oneYear = "One year"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstImageView: UIView!
    @IBOutlet weak var secondImageView: UIView!
    @IBOutlet weak var thirdImageView: UIView!
    @IBOutlet weak var fourthImageView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var monthTitle: UILabel!
    @IBOutlet weak var monthPriceLabel: UILabel!
    @IBOutlet weak var monthPeriodLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var yearTitle: UILabel!
    @IBOutlet weak var yearPriceLabel: UILabel!
    @IBOutlet weak var yearPeriodLabel: UILabel!
    @IBOutlet weak var halfYearView: UIView!
    @IBOutlet weak var halfYearTitle: UILabel!
    @IBOutlet weak var halfYearPriceLabel: UILabel!
    @IBOutlet weak var halfYearPeriodLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var plans: [PlansModel]?
    private var orderRef: String?
    private var planId: Int?
    
    var closure: (() -> Void)?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViews()
        configureLabels()
        fetchProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(checkStatus), name: NSNotification.Name(rawValue: "WebViewWasClosed"), object: nil)
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: false)
    }
    
    // MARK: - Private methods
    private func configureViews() {
        firstImageView.layer.cornerRadius = firstImageView.frame.height / 2 + 5
        secondImageView.layer.cornerRadius = secondImageView.frame.height / 2 + 5
        thirdImageView.layer.cornerRadius = thirdImageView.frame.height / 2 + 5
        fourthImageView.layer.cornerRadius = fourthImageView.frame.height / 2 + 5
        yearView.layer.cornerRadius = 12
        monthView.layer.cornerRadius = 12
        halfYearView.layer.cornerRadius = 12
        let yearTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buyYear))
        yearView.addGestureRecognizer(yearTapGestureRecognizer)
        
        let monthTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buyMonth))
        monthView.addGestureRecognizer(monthTapGestureRecognizer)
        
        let halfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buyHalf))
        halfYearView.addGestureRecognizer(halfTapGestureRecognizer)
    }
    
    private func configureLabels() {
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "119,99 $")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
//        yearOldPriceLabel.attributedText = attributeString
    }
    
    @objc private func checkStatus() {
        if let orderRef = orderRef, let planId = planId {
            NetworkManager.shared.getPaymentStatus(orderReference: orderRef) { data in
                if data.transactionStatus == "Approved" {
                    NetworkManager.shared.createSubscription(data: data, planId: planId) {
                        UserDefaultsManager.saveBool(true, for: .isPremium)
                        UserDefaultsManager.saveInt(planId, for: .planId)
                        self.dismiss(animated: false) {
                            self.closure?()
                        }
                    } failure: { err in
                        ToastView.show(text: "Не удалось создать подписку", in: self)
                    }
                }
                self.orderRef = nil
                self.planId = nil
            } failure: { err in
                ToastView.show(text: "Не удалось совершить платеж", in: self)
            }
        }
    }
    
    private func fetchProducts() {
        NetworkManager.shared.getPlanModels { [self] plansData in
            plans = plansData
            for item in plansData {
                switch item.id {
                case 1:
                    monthPriceLabel.text = String(Int(item.price)) + " UAH"
                case 2:
                    halfYearPriceLabel.text = String(Int(item.price)) + " UAH"
                    let priceForMonth = item.price / item.months
                    halfYearPeriodLabel.text = "/ год* \n" + String(priceForMonth) + " UAH в месяц"
                case 3:
                    yearPriceLabel.text = String(Int(item.price)) + " UAH"
                    let priceForMonth = item.price / item.months
                    yearPeriodLabel.text = "/ пол года* \n" + String(priceForMonth) + " UAH в месяц"
                default:
                    break
                }
            }
        } failure: { err in
            ToastView.show(text: "Не удалось загрузить данные", in: self)
        }
    }
    
    @objc private func buyMonth() {
        guard let plans = plans, let plan = plans.first(where: { $0.id == 1 }) else {
            return
        }

        let orderDate = String(Int(Date().timeIntervalSince1970))
        let orderRef = "BP" + orderDate
        self.orderRef = orderRef
        self.planId = 1
        
        NetworkManager.shared.getPaymentURL(orderReference: orderRef, orderDate: orderDate, amount: String(plan.price), productName: "Подписка " + plan.name) { data in
            guard let stringUrl = data.url, let url = URL(string: stringUrl) else { return }
            let vc = WebViewController()
            vc.configure(url: url)
            self.present(vc, animated: true)
        } failure: { err in
            ToastView.show(text: "Не удалось купить подписку", in: self)
        }
    }
    
    @objc private func buyHalf() {
        guard let plans = plans, let plan = plans.first(where: { $0.id == 2 }) else {
            return
        }

        let orderDate = String(Int(Date().timeIntervalSince1970))
        let orderRef = "BP" + orderDate
        self.orderRef = orderRef
        self.planId = 2
        
        NetworkManager.shared.getPaymentURL(orderReference: orderRef, orderDate: orderDate, amount: String(plan.price), productName: "Подписка " + plan.name) { data in
            guard let stringUrl = data.url, let url = URL(string: stringUrl) else { return }
            let vc = WebViewController()
            vc.configure(url: url)
            self.present(vc, animated: true)
        } failure: { err in
            ToastView.show(text: "Не удалось купить подписку", in: self)
        }
    }
    
    @objc private func buyYear() {
        guard let plans = plans, let plan = plans.first(where: { $0.id == 3 }) else {
            return
        }

        let orderDate = String(Int(Date().timeIntervalSince1970))
        let orderRef = "BP" + orderDate
        self.orderRef = orderRef
        self.planId = 3
        
        NetworkManager.shared.getPaymentURL(orderReference: orderRef, orderDate: orderDate, amount: String(plan.price), productName: "Подписка " + plan.name) { data in
            guard let stringUrl = data.url, let url = URL(string: stringUrl) else { return }
            let vc = WebViewController()
            vc.configure(url: url)
            self.present(vc, animated: true)
        } failure: { err in
            ToastView.show(text: "Не удалось купить подписку", in: self)
        }
    }
}
