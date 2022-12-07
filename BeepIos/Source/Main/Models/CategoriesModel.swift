//
//  CategoriesModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 25.11.2021.
//

import UIKit

struct CategoriesModel: Decodable {
    var id: Int
    var name: String
    var icon: String?
    var isActive: Bool
    var itemCellModel: [ItemCellModel]?
}

struct UserTypeModel: Decodable {
    var id: Int
    var name: String
    var icon: String?
    var isActive: Bool
}

struct ContactModel: Decodable {
    var id: Int
    var name: String
    var icon: String?
    var isActive: Bool
    var pattern: String?
    var categoryId: Int?
}

struct ItemCellModel: Decodable {
    var contactModel: ContModel
    var type: CellType?
}
