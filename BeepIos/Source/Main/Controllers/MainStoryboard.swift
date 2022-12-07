//
//  MainStoryboard.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 18.11.2021.
//

import Foundation

struct MainStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .main
    }

    static var mainViewController: MainViewController {
        instantiateVC(type: MainViewController.self)
    }
    
    static var editAssetViewController: EditAssetViewController {
        instantiateVC(type: EditAssetViewController.self)
    }
    
    static var editProfileViewController: EditProfileViewController {
        instantiateVC(type: EditProfileViewController.self)
    }
    
    static var mainTabBarVC: MainTabBarVC {
        instantiateVC(type: MainTabBarVC.self)
    }
    
    static var addContactTypeViewController: AddContactTypeViewController {
        instantiateVC(type: AddContactTypeViewController.self)
    }
    
    static var editContactTypeViewController: EditContactTypeViewController {
        instantiateVC(type: EditContactTypeViewController.self)
    }
    
    static var addTypeViewController: AddTypeViewController {
        instantiateVC(type: AddTypeViewController.self)
    }
    
    static var categoriesPickerViewController: CategoriesPickerViewController {
        instantiateVC(type: CategoriesPickerViewController.self)
    }
}
