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
    let notificationCenter = UNUserNotificationCenter.current()
    
    func showRequestAlert(with completion: @escaping () -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
            completion()
        }
    }
    
    func scheduleNotification(identifier: String, period: Int, remindNotif: Int, startHour: Int, endHour: Int, minutes: Int, first: Bool = false) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        
        content.title = "CamelApp"
        content.body  = notificationsString[Int(arc4random_uniform(UInt32(notificationsString.count)))]
        content.sound = .default//UNNotificationSound(named: UNNotificationSoundName(rawValue: "camel2.mp3"))
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = startHour // a.m.
        dateComponents.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        if first {
            hours = startHour
            min = 0//period * 60 / remindNotif
        }
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                let identifier = self.stringWithUUID()
                if self.hours != endHour  {
                    self.scheduleNotification(identifier: identifier,
                                              period: period,
                                              remindNotif: remindNotif,
                                              startHour: self.hours,
                                              endHour: endHour,
                                              minutes: self.min)
                    print("hour: \(self.hours)\nminutes: \(self.min) \nidentifier: \(identifier)")
                } else {
                    return
                }
                if (self.min + period * 60 / remindNotif) < 60 {
                    self.min =  self.min + period * 60 / remindNotif
                } else if (self.min + period * 60 / remindNotif) == 60 || remindNotif == 1 {
                    self.hours += 1
                    self.min = 0
                } else {
                    self.hours += 1
                    self.min = period * 60 / remindNotif
                }
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
