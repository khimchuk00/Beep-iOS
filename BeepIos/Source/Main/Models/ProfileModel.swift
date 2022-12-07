//
//  ProfileModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 26.11.2021.
//

import UIKit

struct ProfileModel: Decodable {
    var avatar2: String
    var avatar: String
    var title: String
    var email: String
    var profilePath: String
    var firstName: String
    var lastName: String
    var isPremium: Bool
    var about: String?
    var themeId: Int?
    var contacts: [Contacts] = []
}

struct Contacts: Decodable, Equatable {
    static func == (lhs: Contacts, rhs: Contacts) -> Bool {
        lhs.category == rhs.category
    }
    
    var category: String
    var contacts: [ContModel]
    
    init(category: String) {
        self.category = category
        contacts = []
    }
}

struct ContModel: Decodable {
    var id: Int
    var title: String
    var value: String
    var isActive: Bool
    var pattern: String
    var contactTypeId: Int
    var contactTypeName: String
    var contactTypeIcon: String
    var contactTypeCategoryName: String
    var contactTypeCategoryId: Int
}

struct ProfileModelImage {
    var name: String
    var fio: String
    var about: String
    var avatar: UIImage
    var avatar2: UIImage
    var themeId: Int
}

struct UpdateProfileModel {
    var firstName: String
    var lastName: String
    var about: String
    var updateImage: Bool
    var themeId: Int?
}
