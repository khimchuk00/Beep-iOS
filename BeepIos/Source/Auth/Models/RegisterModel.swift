//
//  UserModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 25.11.2021.
//

import Foundation

struct RegisterModel: Encodable {
    var userTypeId: Int
    var userName: String
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var phone: String
    var referral: String
}
