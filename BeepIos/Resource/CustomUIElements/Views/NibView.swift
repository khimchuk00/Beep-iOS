//
//  NibView.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 24.11.2021.
//

import UIKit

class NibView: UIView {
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        xibSetup()
    }
    
    func xibSetup() {
        guard let loadedView = loadViewFromNib() else { return }
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadedView.frame = bounds
        addSubview(loadedView)
        contentView = loadedView
        layoutSubviews()
    }

    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: Self.self)
        return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView
    }
}
