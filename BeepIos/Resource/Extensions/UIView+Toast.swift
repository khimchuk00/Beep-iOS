//
//  UIView+Toast.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 24.11.2021.
//

import UIKit

private class ToastViewLabel: UILabel {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        super.drawText(in: rect.inset(by: insets))
    }
    
    func configure(text: String) {
        self.text = text
        textColor = .white
        textAlignment = .center
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        clipsToBounds = true
    }
}

class ToastView: UIView {
        
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
    
    private var labelWidth: CGFloat!
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.alpha = 0
        let label = ToastViewLabel()
        label.configure(text: text)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        labelWidth = label.frame.width
        label.fill(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toastFrame() -> CGRect {
        sizeToFit()
        let screenSize = superview?.frame.size ?? UIScreen.main.bounds.size
        let width = labelWidth + 20
        let height = frame.height + 15
        let minX = (screenSize.width - width) / 2.0
        let minY = screenSize.height - 200 - height
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    
    static func show(text: String, in controller: UIViewController, seconds: Double = 2) {
        let toast = ToastView.createToast(text: text)
        controller.view.addSubview(toast)
        toast.frame = toast.toastFrame()
        controller.view.bringSubviewToFront(toast)
        UIView.animate(withDuration: 0.25, animations: { [weak toast] in
            toast?.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak toast] in
                toast?.removeFromSuperview()
            }
        }
    }
    
    static private func createToast(text: String) -> ToastView {
        let toast = ToastView(frame: .zero, text: text)
        return toast
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = toastFrame()
    }
}

