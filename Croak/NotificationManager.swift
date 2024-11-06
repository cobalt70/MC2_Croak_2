//
//  NotificationManager.swift
//  Croak
//
//  Created by jeong hyein on 5/15/24.
//

import UserNotifications
import Foundation

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification authorization granted.")
            } else {
                print("Notification authorization denied.")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "깜빡하기" // 알림 제목 설정
        content.body = "띠링! 👀 깜빡 할 시간입니다." // 알림 내용 설정
        content.sound = UNNotificationSound.default
        //content.subtitle = "I am Tester!"
        //content.badge = 1
     
        // trigger - time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    

    func scheduleNotification(at date: Date, identifier: String) {
           let content = UNMutableNotificationContent()
           content.title = "깜빡하기" // 알림 제목 설정
           content.body = "띠링! 👀 깜빡 할 시간입니다." // 알림 내용 설정
           content.sound = UNNotificationSound.default
           
           let components = Calendar.current.dateComponents([.hour, .minute], from: date)
           let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
           
           let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
           notificationCenter.add(request)
       }

    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    func cancelNotification(identifier: String) {
           notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
       }
}
