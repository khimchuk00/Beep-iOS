//
//  ActivateStikerViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit
import CoreNFC

class ActivateStikerViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stikerTitleLabel: UILabel!
    @IBOutlet weak var stikerNameLabel: UILabel!
    @IBOutlet weak var startButton: MainButton!
    @IBOutlet weak var orderButton: UIButton!
    
    private var session: NFCNDEFReaderSession?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureContainerView()
        configureStikerNameLabel()
    }
    
    // MARK: - Actions
    @IBAction func backButtonDidTap() {
        dismiss(animated: false)
    }
    
    @IBAction func startButtonDidTap() {
        session?.invalidate()
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Держи около NFC метки"
        session?.begin()
    }
    
    @IBAction func orderButtonDidTap() {
        guard let url = URL(string: "tg://resolve?domain=beepnfc") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            ToastView.show(text: "Телеграм не установлен", in: self)
        }
    }
    
    // MARK: - Private methods
    private func localize() {
        
    }
    
    private func configureStikerNameLabel() {
        stikerTitleLabel.text = UserDefaultsManager.getString(for: .userName)
    }
    
    private func configureContainerView() {
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.cornerRadius = 20
    }
}

extension ActivateStikerViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead && readerError.code != .readerSessionInvalidationErrorUserCanceled {
                let allertController = UIAlertController(title: "Сессия завершена", message: error.localizedDescription, preferredStyle: .alert)
                allertController.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self.present(allertController, animated: false)
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
                for record in message.records {
                    if let string = String(data: record.payload, encoding: .ascii) {
                        print(string)
                    }
                }
            }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {}
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str = UserDefaultsManager.getString(for: .fullLink)
        let strToUInt8: [UInt8] = [UInt8](str.utf8)
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "Обнаружено больше 1 тега"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }

        guard let tag = tags.first else { return }
        session.connect(to: tag) { error in
            guard error == nil else {
                session.invalidate(errorMessage: "Не удалось подключиться")
                return
            }

            tag.queryNDEFStatus { status, capacity, error in
                guard error == nil else {
                    session.invalidate(errorMessage: "Не известный статус тега")
                    return
                }

                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Тег не поддерживаеться")
                case .readWrite:
                    tag.readNDEF { message, error in
                        if let decodedString = String(data: message?.records.first?.payload ?? Data(), encoding: .utf8), (decodedString.contains("http://beep.in.ua/77777") || (decodedString.contains(str))) {
                            tag.writeNDEF(.init(records: [NFCNDEFPayload(format: .nfcWellKnown, type: Data([06]), identifier: Data([0x0C]), payload: Data(strToUInt8))])) { error in
                                guard error == nil else {
                                    session.invalidate(errorMessage: "Не удалось записать данные \(error!)")
                                    return
                                }
                                session.alertMessage = "Данные успешно записаны"
                                session.invalidate()
                            }
                        } else {
                            session.invalidate(errorMessage: "Используйте только теги BEEP")
                        }
                    }
                case .readOnly:
                    session.invalidate(errorMessage: "Тег только для считывания")
                @unknown default:
                    session.invalidate(errorMessage: "Не известный статус даного тега")
                }
            }
        }
    }
}
