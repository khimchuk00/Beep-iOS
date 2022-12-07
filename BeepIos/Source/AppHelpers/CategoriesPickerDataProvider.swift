//
//  CategoriesPickerDataProvider.swift
//  PauRueDexWallet
//
//  Created by Valentyn Khimchuk on 18.05.2021.
//

import Foundation

class CategoriesPickerDataProvider: PickerDataProvider {

    typealias PickerSelectCategoryAction = (String) -> Void
    private var selectAction: PickerSelectCategoryAction
    var cancelAction: PickerCancelAction?
    
    private var categories: [String] = []
    private var selectedCategory: String?
    
    init(categories: [String], select: @escaping PickerSelectCategoryAction, cancel: PickerCancelAction? = nil) {
        self.categories = categories
        self.cancelAction = cancel
        self.selectAction = select
    }
    
    var defaultSelectedIndex: Int {
        if let category = selectedCategory {
            return categories.firstIndex(of: category) ?? 0
        } else {
            return 0
        }
    }
    
    func rowsCount() -> Int {
        categories.count
    }
    
    func titleForRow(at index: Int) -> String {
        categories[index]
    }
    
    func donePressed(with index: Int) {
        selectAction(categories[index])
    }
    
    func cancelPressed() {
        cancelAction?()
    }
}
