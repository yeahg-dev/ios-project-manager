//
//  UserNotificationHandler.swift
//  ProjectManager
//
//  Created by 1 on 2022/07/13.
//

import Foundation
import UserNotifications

struct UserNotificationHandler {
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestNotification(of content: UserNotificationContent,
                             when dateComponent: DateComponents,
                             identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = content.title
        content.body = content.body
        
//        let trigger = UNCalendarNotificationTrigger(
//                 dateMatching: dateComponent, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                    content: content, trigger: trigger)

        userNotificationCenter.add(request) { (error) in
           if error != nil {
               print("노티 등록 실패")
              // Handle any errors.
           }
        }
    }
    
    func removeNotification(of identifier: String) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
