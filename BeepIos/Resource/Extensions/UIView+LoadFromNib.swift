//
//  UIView+LoadFromNib.swift
//  PauRueDexWallet
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import UIKit

extension UIView {
    
    class func loadViewFromNib<T>(owner: Any? = nil) -> T? where T: UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        let view = nib.instantiate(withOwner: owner, options: nil).first as? T
        return view
    }
}

protocol NibLoadable {
    static func nibName() -> String
}

extension NibLoadable where Self: UIView {
    static func nibName() -> String {
        let name = String(describing: Self.self)
        return name.components(separatedBy: ".").last!
    }

    func loadFromNib() {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = selfType.nibName()
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Error loading nib with name \(nibName)")
        }

        addStretchedSubview(view)
    }

    private func addStretchedSubview(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
