//
//  PickerDataProvider.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//


import Foundation

protocol PickerDataProvider: AnyObject {
    
    var defaultSelectedIndex: Int { get }
    func rowsCount() -> Int
    func titleForRow(at index: Int) -> String
    
    // MARK: - Actions
    func donePressed(with index: Int)
    func cancelPressed()
    typealias PickerCancelAction = () -> Void
    var cancelAction: PickerCancelAction? { get set }
}
