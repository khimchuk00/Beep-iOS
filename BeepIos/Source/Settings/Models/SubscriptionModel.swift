//
//  SubscriptionModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 21.01.2022.
//

import Foundation

struct SubscriptionModel: Decodable {
    var planId: Int
    var plan: PlansModel
    var user: SubUserModel
}

struct SubUserModel: Decodable {
    var userName: String
}
