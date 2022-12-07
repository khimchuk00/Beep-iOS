//
//  WebViewViewController.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 20.01.2022.
//

import UIKit
import WebKit
import SafariServices

class WebViewController: UIViewController {
    private var webView: WKWebView!
    private var url: URL!
    private var timer: Timer?
    
    var onDismiss: (() -> Void)?
    
//    func createButton() {
//        let button  = UIButton()
//        button.frame = CGRect(x: 20, y: 70, width: 70, height: 30)
//        button.layer.cornerRadius = 5
////        button.backgroundColor = Theme.Colors.themeMainDark
//        button.setTitle("Close ", for: .normal)
//        button.addTarget(self, action: #selector(closeView) , for: .touchUpInside)
//        button.semanticContentAttribute = .forceRightToLeft
//
//        self.view.addSubview(button)
//    }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createButton()
        createTimer()
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WebViewWasClosed"), object: nil)
    }
    
    func configure(url: URL) {
        self.url = url
    }
    
    // MARK: - Private methods
    private func createTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.3,
                                         target: self,
                                         selector: #selector(fetchURL),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func fetchURL() {
        if let url = webView.url, (url.absoluteString.range(of: "https://beep.in.ua") != nil) {
            timer?.invalidate()
            closeView()
        }
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
        onDismiss?()
    }
}

// MARK: - UIWebViewDelegate, WKNavigationDelegate
extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        closeView()
    }
}
