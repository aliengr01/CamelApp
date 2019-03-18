//
//  Globals.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 2/17/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import UIKit

struct Globals {
    
    struct Colors {
        
        static let orangeColor = UIColor(red: 253/255, green: 148/255, blue: 38/255, alpha: 1.0)
        static let blackColor  = UIColor.black
        static let whiteColor  = UIColor.white
        
    }
    
    struct AppThemeKey {
        
        static let mainThemeKey     = "MainAppColor"
        static let labelsThemeKey   = "LabelsAppColor"
        static let buttonsThemeKey  = "ButtonsAppColor"
        static let viewsThemeKey    = "ViewsAppColor"
        static let plusMinusThemeKey = "PlusMinusButtonAppColor"
        static let countNotifLabel  = "CountNotifLabelAppColor"
        static let descNotifLabel   = "DescNotifLabelAppColor"
        
    }
    
    struct NotificationsKey {
        
        static let fromDate    = "NotificationFromDate"
        static let toDate      = "NotificationToDate"
        static let remindNotif  = "NotificationsCount"
        static let periodNotif = "NotificationsPeriod"
        
    }
    
    
}
