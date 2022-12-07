//
//  LoginResultModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 25.11.2021.
//

import Foundation

struct LoginResultModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case message
        case statusCode
    }
    
    var accessToken: String?
    let message: String?
    let statusCode: Int?
}

struct RegisterResultModel: Decodable {
    var email: String
    var password: String?
    let message: String?
    let statusCode: Int?
}
