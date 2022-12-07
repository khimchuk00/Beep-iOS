//
//  UserDefaultsManager.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 22.11.2021.
//

import Foundation

class UserDefaultsManager {
    private static var userDefaults = UserDefaults.standard
    
    // MARK: - Configs
    enum ConfigID: String, CaseIterable {
        case localization
        case EN
        case IT
        case UA
        case userName
        case fullLink
        case accessToken
        case theme
        case profileImage
        case isPremium
        case isLoginned
        case subName
        case planId
        case switcherIsOn
        
        func associatedWith<T>(type: T.Type) -> Bool {
            switch self {
            case .userName, .subName, .fullLink, .accessToken, .localization, .EN, .IT, .UA:
                return type == String.self
            case .theme, .planId:
                return type == Int.self
            case .profileImage:
                return type == Data.self
            case .isPremium, .isLoginned, .switcherIsOn:
                return type == Bool.self
            }
        }
        
        func defaultValue() -> Any? {
            switch self {
            case .userName, .fullLink, .accessToken, .subName:
                return ""
            case .localization:
                return "RU "
            case .UA:
                return "UK "
            case .IT:
                return "IT "
            case .EN:
                return "EN "
            case .theme:
                return 1
            case .planId:
                return 0
            case .profileImage:
                return Data()
            case .isPremium, .isLoginned, .switcherIsOn:
                return false
            }
        }
    }
    
    // MARK: - Save config
    static func saveBool(_ val: Bool, for identifire: ConfigID) {
        saveConfig(val, for: identifire)
    }
    
    static func saveString(_ val: String, for identifire: ConfigID) {
        saveConfig(val, for: identifire)
    }
    
    static func saveString(_ val: String, for identifire: String) {
        saveStringConfig(val, for: identifire)
    }
    
    static func saveInt(_ val: Int, for identifire: ConfigID) {
        saveConfig(val, for: identifire)
    }
    
    static func saveInt(_ val: Int, for identifire: String) {
        saveStringConfig(val, for: identifire)
    }
    
    static func saveData(_ val: Data, for identifire: ConfigID) {
        saveConfig(val, for: identifire)
    }
    
    // MARK: - Get config
    static func getBool(for identifire: ConfigID) -> Bool {
        return getConfig(for: identifire)
    }
    
    static func getString(for identifire: ConfigID) -> String {
        return getConfig(for: identifire)
    }
    
    static func getString(for identifire: String) -> String {
        return getStringConfig(for: identifire)
    }
    
    static func getInt(for identifire: ConfigID) -> Int {
        return getConfig(for: identifire)
    }
    
    static func getInt(for identifire: String) -> Int {
        return getStringConfig(for: identifire)
    }
    
    static func getData(for identifire: ConfigID) -> Data {
        return getConfig(for: identifire)
    }
    
    // MARK: - Reset
    static func reset() {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}

// MARK: - Private methods
private extension UserDefaultsManager {
    static func getConfig<T>(for identifire: ConfigID) -> T {
        if let val: T = getOptionalConfig(for: identifire) {
            return val
        } else {
            fatalError("Default value for \(identifire) doesn't fit to \(T.self)")
        }
    }
    
    static func getStringConfig<T>(for identifire: String) -> T {
        if let val: T = getOptionalString(for: identifire) {
            return val
        } else {
            fatalError("Default value for \(identifire) doesn't fit to \(T.self)")
        }
    }
    
    static func getOptionalConfig<T>(for identifire: ConfigID) -> T? {
        if identifire.associatedWith(type: T.self) {
            if let val = userDefaults.object(forKey: identifire.rawValue) as? T {
                return val
            } else {
                return identifire.defaultValue() as? T
            }
        } else {
            fatalError("\(identifire) can't be inited with type \(T.self)")
        }
    }
    
    static func getOptionalString<T>(for identifire: String) -> T? {
        if let val = userDefaults.object(forKey: identifire) as? T {
            return val
        } else {
            return "No value" as? T
        }
    }
    
    static func saveConfig<T>(_ val: T, for identifire: ConfigID) {
        if identifire.associatedWith(type: T.self) {
            userDefaults.set(val, forKey: identifire.rawValue)
        }
    }
    
    static func saveStringConfig<T>(_ val: T, for identifire: String) {
        userDefaults.set(val, forKey: identifire)
    }
}
