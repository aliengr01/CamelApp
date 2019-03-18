//
//  NotificationManager.swift
//  CamelApp
//
//  Created by Igor Ryazancev on 2/23/19.
//  Copyright © 2019 Igor Ryazancev. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    private var hours = 0
    private var min = 0
    
    static let shared = NotificationManager()
    
    private init() {}
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func showRequestAlert(with completion: @escaping () -> Void) {
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
            completion()
        }
        
        ////for check user request
//        notificationCenter.getNotificationSettings { (settings) in
//            if settings.authorizationStatus != .authorized {
//                // Notifications not allowed
//            }
//        }
       
    }
    
    func scheduleNotification(identifier: String, period: Int, remindNotif: Int, startHour: Int, endHour: Int, minutes: Int, first: Bool = false) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        
        content.title = "CamelApp"
        content.body  = notificationsString[Int(arc4random_uniform(31))]
        content.sound = UNNotificationSound.default
        content.badge = 1

        var dateComponents = DateComponents()
        //dateComponents.weekday = 5
        dateComponents.hour = startHour // a.m.
        dateComponents.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        
        
        if first {
            hours = startHour
            min = period * 60 / remindNotif
        }
        
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                let identifier = self.stringWithUUID()
                if self.hours < endHour {
                    self.scheduleNotification(identifier: identifier,
                                                  period: period,
                                              remindNotif: remindNotif,
                                               startHour: self.hours,
                                                 endHour: endHour,
                                                 minutes: self.min)
                } else {
                    return
                }
                
                if self.min < 60 {
                    self.min =  self.min + period * 60 / remindNotif
                } else {
                    self.hours += 1
                    self.min = period * 60 / remindNotif
                }
                
                
                print("hour: \(self.hours)\nminutes: \(self.min) \nidentifier: \(identifier)")
                
            }
            
        }
        
        
        
        
    }
    
    ////Generate ID for notification
    func stringWithUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)!
        return uuidString as String
    }
    
    func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
}
