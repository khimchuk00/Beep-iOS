//
//  QrCodeViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit
import SafariServices

class QrCodeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var qrCodeContainerView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var shareButton: MainButton!
    
    private var brightness = 0.5
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        brightness = UIScreen.main.brightness
    }
    
    // MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIScreen.main.brightness = CGFloat(1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        configureQRCode()
        configureLinkLabel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIScreen.main.brightness = brightness
    }
    
    // MARK: - Actions
    @IBAction func shareButtonDidTap() {
        let textToShare = [UserDefaultsManager.getString(for: .fullLink)]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.markupAsPDF, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.message, UIActivity.ActivityType.mail, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.saveToCameraRoll]
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func localize() {
        tabBarController?.tabBar.items?[0].title = "TabBar-card-title".localized()
        tabBarController?.tabBar.items?[1].title = "TabBar-code-title".localized()
        tabBarController?.tabBar.items?[2].title = "TabBar-settings-title".localized()
    }
    
    private func configureLinkLabel() {
        let string = NSMutableAttributedString(string: "Моя ссылка:  ", attributes: [.foregroundColor: UIColor.black,
                                                                                                .font: Theme.Fonts.bold(14)])
        
        string.append(NSAttributedString(string: "beep.in.ua/", attributes: [.foregroundColor: Theme.Colors.mainBlue,
                                                                                                             .font: Theme.Fonts.light(14)]))
        string.append(NSAttributedString(string: UserDefaultsManager.getString(for: .userName), attributes: [.foregroundColor: Theme.Colors.mainBlue,
                                                                                                             .font: Theme.Fonts.light(14)]))
        linkLabel.attributedText = string
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openURL))
        linkLabel.addGestureRecognizer(tapGestureRecognizer)
        linkLabel.isUserInteractionEnabled = true
    }
    
    @objc private func openURL() {
        guard let url = URL(string: UserDefaultsManager.getString(for: .fullLink)) else { return }
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .popover
        present(viewController, animated: true)
    }
    
    private func configureQRCode() {
        addShadow(to: qrCodeContainerView)
        DispatchQueue.global(qos: .userInteractive).async {
            let QRCode = self.qrImage(using: Theme.Colors.mainRed)
            DispatchQueue.main.async {
                self.qrCodeImageView.image = QRCode
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    private func addShadow(to view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.buttonBorderColor.cgColor
        view.backgroundColor = Theme.Colors.qrCodeBgColor
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
}

extension QrCodeViewController {

   /// Creates a QR code for the current URL in the given color.
   func qrImage(using color: UIColor, logo: UIImage? = nil) -> UIImage? {

      guard let tintedQRImage = qrImage?.tinted(using: color) else {
         return nil
      }

      guard let logo = logo?.cgImage else {
         return UIImage(ciImage: tintedQRImage)
      }

      guard let final = tintedQRImage.combined(with: CIImage(cgImage: logo)) else {
        return UIImage(ciImage: tintedQRImage)
      }

    return UIImage(ciImage: final)
  }

  /// Returns a black and white QR code for this URL.
  var qrImage: CIImage? {
    guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    let qrData = UserDefaultsManager.getString(for: .fullLink).data(using: String.Encoding.ascii)
    qrFilter.setValue(qrData, forKey: "inputMessage")

    let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
    return qrFilter.outputImage?.transformed(by: qrTransform)
  }
}

extension CIImage {
  /// Inverts the colors and creates a transparent image by converting the mask to alpha.
  /// Input image should be black and white.
  var transparent: CIImage? {
     return inverted?.blackTransparent
  }

  /// Inverts the colors.
  var inverted: CIImage? {
      guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

    invertedColorFilter.setValue(self, forKey: "inputImage")
    return invertedColorFilter.outputImage
  }

  /// Converts all black to transparent.
  var blackTransparent: CIImage? {
      guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
    blackTransparentFilter.setValue(self, forKey: "inputImage")
    return blackTransparentFilter.outputImage
  }

  /// Applies the given color as a tint color.
  func tinted(using color: UIColor) -> CIImage? {
     guard
        let transparentQRImage = transparent,
        let filter = CIFilter(name: "CIMultiplyCompositing"),
        let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

    let ciColor = CIColor(color: color)
    colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
    let colorImage = colorFilter.outputImage

    filter.setValue(colorImage, forKey: kCIInputImageKey)
    filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

    return filter.outputImage!
  }
}

extension CIImage {

  /// Combines the current image with the given image centered.
  func combined(with image: CIImage) -> CIImage? {
    guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
    let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
    combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
    combinedFilter.setValue(self, forKey: "inputBackgroundImage")
    return combinedFilter.outputImage!
  }
}
