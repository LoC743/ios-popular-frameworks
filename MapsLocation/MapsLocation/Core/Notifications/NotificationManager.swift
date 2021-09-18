//
//  NotificationManager.swift
//  MapsLocation
//
//  Created by Alexey on 18.09.2021.
//

import NotificationCenter

final class NotificationManager {
    
    // MARK: - Public
    
    func sendTestNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeIntervalNotificatioTrigger()
            )
        }
    }
    
    
    // MARK: - Private
    
    private func sendNotificatioRequest(content: UNNotificationContent,
                                trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Прошло 30 секунд"
        content.badge = -1
        
        return content
    }
    
    private func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: 30,
            repeats: false
        )
    }
    
}

