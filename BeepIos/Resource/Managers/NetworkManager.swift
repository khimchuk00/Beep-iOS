//
//  NetworkManager.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 24.11.2021.
//

import Alamofire
import Moya
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
    let baseURL = "https://server.beep.in.ua/"
    
    func getPaymentURL(orderReference: String, orderDate: String, amount: String, productName: String, success: @escaping (_ data: PaymentModel) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "merchantAccount": "test_merch_n1",
            "merchantDomainName": "www.market.ua",
            "returnUrl": "https://beep.in.ua",
            "merchantSignature": "test_merch_n1;www.market.ua;\(orderReference);\(orderDate);\(amount);UAH;\(productName);1;1".hmac(algorithm: .MD5, key: "flk3409refn54t54t*FNJRET"),
            "orderReference": orderReference,
            "orderDate": orderDate,
            "amount": amount,
            "currency": "UAH",
            "productName[]": productName,
            "productPrice[]": 1,
            "productCount[]": 1
        ]
        
        AF.request("https://secure.wayforpay.com/pay?behavior=offline", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(PaymentModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func getPaymentStatus(orderReference: String, success: @escaping (_ data: TransactionStatus) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "transactionType": "CHECK_STATUS",
//            "merchantDomainName": "www.market.ua",
            "merchantAccount": "test_merch_n1",
            "merchantSignature": "test_merch_n1;\(orderReference)".hmac(algorithm: .MD5, key: "flk3409refn54t54t*FNJRET"),
            "orderReference": orderReference,
            "apiVersion": "1"
        ]
        
        AF.request("https://api.wayforpay.com/api", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(TransactionStatus.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func createSubscription(data: TransactionStatus, planId: Int, success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "planId": planId,
            "merchantAccount": data.merchantAccount,
            "orderReference": data.orderReference,
            "authCode": data.authCode,
            "processingDate": String(data.processingDate),
            "transactionStatus": "Approved"
        ]
        
        AF.request(baseURL + "subscriptions", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, response.error == nil else {
                failure(response.error)
                return }
            success()
        }
    }
    
    func getSubscriptions(success: @escaping (_ data: [SubscriptionModel]) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "subscriptions", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode([SubscriptionModel].self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func getPlanModels(success: @escaping (_ data: [PlansModel]) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "plans", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode([PlansModel].self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func madeLogin(login: String, password: String, success: @escaping (_ data: LoginResultModel) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "email": login,
            "password": password
        ]
        AF.request(baseURL + "auth/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(LoginResultModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func register(registerModel: RegisterModel, success: @escaping (_ data: RegisterResultModel) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "userTypeId": registerModel.userTypeId,
            "userName": registerModel.userName,
            "email": registerModel.email,
            "password": registerModel.password,
            "firstName": registerModel.firstName,
            "lastName": registerModel.lastName,
            "phone": registerModel.phone
        ]
        AF.request(baseURL + "auth/register", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(RegisterResultModel.self, from: data) else {
                failure(response.error)
                return }
            success(RegisterResultModel(email: value.email, password: registerModel.password, message: value.message, statusCode: value.statusCode))
        }
    }
    
    func checkExistingUserName(name: String, success: @escaping (_ data: Bool) -> Void) {
        AF.request(baseURL + "users/check-user-name/" + name, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(Bool.self, from: data) else {
                success(false)
                return }
            success(value)
        }
    }
    
    func getEmailCode(email: String, result: @escaping (_ data: Bool) -> Void) {
        let params: [String : Any] = [
            "email": email
        ]
        
        AF.request(baseURL + "auth/reset-password-request/" + email, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                result(true)
            case .failure(let error):
                result(false)
            }
        }
    }
    
    func getCategoriesList(success: @escaping (_ data: [CategoriesModel]) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "categories", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode([CategoriesModel].self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func getUserTypes(success: @escaping (_ data: [UserTypeModel]) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "user-types", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode([UserTypeModel].self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func getContactTypes(success: @escaping (_ data: [ContactModel]) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "contact-types", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode([ContactModel].self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func createContactTypes(categoryId: Int, pattern: String, name: String, isActive: Bool, image: Data, success: @escaping (_ data: LoginResultModel) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "file", fileName: "img-qwqewewew.jpg", mimeType: "image/png")
            multipartFormData.append(categoryId.description.data(using: .utf8)!, withName: "categoryId")
            multipartFormData.append(pattern.description.data(using: .utf8)!, withName: "pattern")
            multipartFormData.append(name.description.data(using: .utf8)!, withName: "name")
            multipartFormData.append(isActive.description.data(using: .utf8)!, withName: "isActive")
        }, to: baseURL + "contact-types", method: .post, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(LoginResultModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func createContact(contactTypeId: Int, title: String, value: String, isActive: Bool, success: @escaping (_ data: LoginResultModel) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "contactTypeId": String(contactTypeId),
            "title": title,
            "value": value,
            "isActive": isActive
        ]
        AF.request(baseURL + "contacts/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(LoginResultModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func getProfileData(success: @escaping (_ data: ProfileModel) -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "business-card/get-my-profile", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(ProfileModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func logout(success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "auth/log-out", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard response.error != nil else {
                failure(response.error)
                return }
            success()
        }
    }
    
    func updateContact(id: Int, contactTypeId: Int, title: String, value: String, isActive: Bool, success: @escaping (_ data: LoginResultModel) -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "contactTypeId": String(contactTypeId),
            "title": title,
            "value": value,
            "isActive": isActive
        ]
        AF.request(baseURL + "contacts/\(id)", method: .patch, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard let data = response.data, let value = try? JSONDecoder().decode(LoginResultModel.self, from: data) else {
                failure(response.error)
                return }
            success(value)
        }
    }
    
    func updateProfileData(updateProfileModel: UpdateProfileModel, image: Data, updateImage: String, success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "file", fileName: "img-qqqqq.jpg", mimeType: "image/png")
            multipartFormData.append(updateImage.description.data(using: .utf8)!, withName: "updateImage")
            multipartFormData.append(updateProfileModel.firstName.description.data(using: .utf8)!, withName: "firstName")
            multipartFormData.append(updateProfileModel.lastName.description.data(using: .utf8)!, withName: "lastName")
            multipartFormData.append(updateProfileModel.about.description.data(using: .utf8)!, withName: "about")
            multipartFormData.append(updateProfileModel.themeId?.description.data(using: .utf8) ?? 1.description.data(using: .utf8)!, withName: "themeId")
        }, to: baseURL + "users/update-my-profile", method: .post, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).response { result in
            guard result.data != nil else {
                failure(result.error)
                return }
            success()
        }
    }
    
    func updateSubscriptionStatus(isActive: Bool, success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "isPremium": isActive,
            "updateImage": false
        ]
        AF.request(baseURL + "users/update-my-profile", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard response.data != nil else {
                failure(response.error)
                return }
            success()
        }
    }
    
    func updateMainImage(imageData: Data) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "img-qasadaza3123zz12123qqqe.jpg", mimeType: "image/png")
            multipartFormData.append("true".description.data(using: .utf8)!, withName: "updateImage")
        }, to: baseURL + "users/update-avatar2", method: .post, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).response { result in
            print(result)
        }
    }
    
    func deleteProfile(success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        AF.request(baseURL + "users/delete-me", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard response.data != nil else {
                failure(response.error)
                return }
            success()
        }
    }
    
    func changePassword(password: String, confirmPassword: String, success: @escaping () -> Void, failure: @escaping (AFError?) -> Void) {
        let params: [String : Any] = [
            "password": password,
            "confirmPassword": confirmPassword
        ]
        AF.request(baseURL + "auth/change-password", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaultsManager.getString(for: .accessToken))"]).responseJSON { response in
            guard response.data != nil else {
                failure(response.error)
                return }
            success()
        }
    }
}
