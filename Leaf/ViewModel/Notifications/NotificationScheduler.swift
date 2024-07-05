//
//  NotificationScheduler.swift
//  Leaf
//
//  Created by Faiz Hadiyan Firza on 04/07/24.
//

import Foundation
import UserNotifications

struct NotificationScheduler {
    static func scheduleNotifications(for note: Note) {
        let intervals: [TimeInterval] = [70, 86400, 604800, 1209600, 2592000, 31536000] // 70 seconds, 1 day, 7 days, 14 days, 30 days, 365 days

        let content = UNMutableNotificationContent()
        content.title = "Review your note"
        content.body = note.title
        content.userInfo = ["noteID": note.id.uuidString]
        content.sound = .default

        for interval in intervals {
            let triggerDate = note.creationDate.addingTimeInterval(interval)
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
            print(trigger)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    }
}
