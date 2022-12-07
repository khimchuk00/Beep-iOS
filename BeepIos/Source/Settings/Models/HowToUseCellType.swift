//
//  HowToUseCellType.swift
//  BeepIos
//
//  Created by Valentyn Khimchuk on 29.11.2021.
//

import UIKit

enum HowToUseCellType {
    case newIPhones
    case oldIPhones
    case androids
    case qrCode
    
    var title: String {
        switch self {
        case .newIPhones:
            return "BEEP для новых iPhones"
        case .oldIPhones:
            return "BEEP для старых iPhones"
        case .androids:
            return "BEEP для Androids"
        case .qrCode:
            return "BEEP для QR Code"
        }
    }
    
    var image: UIImage {
        switch self {
        default:
            return UIImage(named: "apple_img")!
        }
    }
    
    var description: String {
        switch self {
        case .newIPhones:
            return "iPhone XR и более новые модели"
        case .oldIPhones:
            return "iPhone X и более старые модели"
        case .androids:
            return "Должен быть включен NFC"
        case .qrCode:
            return "Для всех телефонов"
        }
    }
    
    var detailsModel: HowToUseDetailsModel {
        switch self {
        case .newIPhones:
            return HowToUseDetailsModel(title: "BEEP для новых iPhones", description: "iPhone XR, XS, 11, 12, 13", firstText: "Чтобы поделиться контактами с новыми iPhone, сдвиньте и удерживайте устройство BEEP горизонтально возле самого верха iPhone, пока не появится push-уведомление.", image: UIImage(named: "apple_img")!, imortantText: "Важно!", secondText: "Экран телефона должен быть включен, режим полета должен быть выключен, а камера не должна быть открыта. Если не работает, выключите и снова включите экран телефона. Это часто помогает", escapeText: "У вас всегда есть выход", thirdText: "Если вы испробовали все, но устройство BEEP все еще не работает, вы всегда можете использовать QR-код BEEP, чтобы поделиться своим профилем! QR-код BEEP можно найти в нижней части вашего приложения")
        case .oldIPhones:
            return HowToUseDetailsModel(title: "BEEP для старых iPhones", description: "iPhone 6, 7, 8, Х", firstText: "Для обмена контактами на старые модели iPhone рекомендуется использовать QR-код BEEP. Это подходит для любого iPhone. Вы также можете поделиться, нажав виджет NFC в центре управления.", image: UIImage(named: "apple_img")!, imortantText: "Важно!", secondText: "Экран должен быть включен, авиарежим должен быть выключен, а камера не должна быть открыта.", escapeText: "У вас всегда есть выход", thirdText: "Если вы испробовали все, но устройство BEEP все еще не работает, вы всегда можете использовать QR-код BEEP, чтобы поделиться своим профилем! QR-код BEEP можно найти в нижней части вашего приложения")
        case .androids:
            return HowToUseDetailsModel(title: "BEEP для Androids", description: "Каждый Андроид с NFC (почти все)", firstText: "Чтобы поделиться контактами с пользователями Android, проведите BEEP по центральной задней части их телефона. У каждого Android свое место для считывающего устройства NFC, но обычно оно находится рядом с центром.", image: UIImage(named: "apple_img")!, imortantText: "Важно!", secondText: "В отличие от iPhone, у Android есть возможность отключить NFC в настройках. Прежде чем прикоснуться к Android, убедитесь, что NFC у них включен. Чтобы включить NFC, найдите NFC в настройках телефона Android.", escapeText: "У вас всегда есть выход", thirdText: "Если вы испробовали все, но устройство BEEP все еще не работает, вы всегда можете использовать QR-код BEEP, чтобы поделиться своим профилем! QR-код BEEP можно найти в нижней части вашего приложения")
        case .qrCode:
            return HowToUseDetailsModel(title: "BEEP с твоим QR-кодом", description: "Все iPhone и Android телефоны", firstText: "Чтобы поделиться контактыми с помощью QR-кода BEEP, откройте приложение BEEP и коснитесь символа QR-кода внизу. На большинстве устройств для считывания QR-кода не требуется приложение QR-сканера, достаточно использовать обычную камеру.", image: UIImage(named: "apple_img")!, imortantText: "Важно!", secondText: "Вы можете добавить QR-код в свой кошелек Apple или Google. Это позволит вам делиться своей цифровой визитной карточкой BEEP быстрее, чем когда-либо.", escapeText: "У вас всегда есть выход", thirdText: "Если вы испробовали все, но устройство BEEP все еще не работает, вы всегда можете использовать QR-код BEEP, чтобы поделиться своим профилем! QR-код BEEP можно найти в нижней части вашего приложения")
        }
    }
}
