//
//  PaymentModel.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 19.01.2022.
//

import Foundation

struct PaymentModel: Decodable {
    var url: String?
    var orderReference: String?
}
 
struct TransactionStatus: Decodable {
    var authCode: String
    var processingDate: Int
    var transactionStatus: String
    var merchantAccount: String
    var orderReference: String
}
