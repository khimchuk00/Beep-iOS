//
//  PlansModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 20.01.2022.
//

import Foundation

struct PlansModel: Decodable {
    var id: Int
    var name: String
    var price: Double
    var months: Double
}
