//
//  UserDataManager.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 26.11.2021.
//

import UIKit

class UserDataManager {
 
    static let shared = UserDataManager()
    
    private init() {}
    
    var profileData: ProfileModel!
    var updateProfileData: UpdateProfileModel!
}
