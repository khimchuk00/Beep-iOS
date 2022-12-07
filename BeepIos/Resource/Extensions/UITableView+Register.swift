//
//  UITableView+Register.swift
//  PauRueDexWallet
//
//  Created by Valentyn Khimchuk on 18.11.2021.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let identifier = "\(cellType)"
        let cellnibName = "\(cellType)"
        let nib = UINib(nibName: cellnibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func cell<T: UITableViewCell>(cellType: T.Type, nibName: String? = nil, identifier: String? = nil) -> T {
        let identifier = identifier ?? "\(cellType)"
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            print("cell own type")
            return T.loadViewFromNib() ?? T()
        }
        
        return cell
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(type: T.Type, nibName: String? = nil, customIdentifier: String? = nil) {
        let identifier = customIdentifier ?? "\(type)"
        let nibName = nibName ?? "\(type)"
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func headerFooter<T: UITableViewHeaderFooterView>(type: T.Type, nibName: String? = nil, identifier: String? = nil) -> T {
        let identifier = identifier ?? "\(type)"
        guard let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            return T.loadViewFromNib() ?? T()
        }
        return headerFooter
    }
}
