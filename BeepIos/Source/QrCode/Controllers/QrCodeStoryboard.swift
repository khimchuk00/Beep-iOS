//
//  QrCodeStoryboard.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 17.11.2021.
//

import Foundation

struct QrCodeStoryboard: StoryboardInstantiable {
    
    static var storyboard: Storyboard {
        .qrCode
    }

    static var qrCodeViewController: QrCodeViewController {
        instantiateVC(type: QrCodeViewController.self)
    }
}
