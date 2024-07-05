//
//  LeafApp.swift
//  Leaf
//
//  Created by Marizka Ms on 24/06/24.
//

import SwiftUI
import SwiftData
import UserNotifications


@main
struct LeafApp: App {
    
    @Environment(\.modelContext) var modelContext
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            AllBookView()
//                .background(
//                                    NavigationLink(
//                                        destination: NoteDetailView(note: noteToNavigate),
//                                        isActive: Binding(
//                                            get: { noteToNavigate != nil },
//                                            set: { if !$0 { noteToNavigate = nil } }
//                                        )
//                                    ) {
//                                        EmptyView()
//                                    }
//                                )
        }
        .modelContainer(for: [Book.self, Note.self])
//        .onAppear {
//                    NotificationCenter.default.addObserver(forName: .navigateToNote, object: nil, queue: .main) { notification in
//                        if let noteID = notification.userInfo?["noteID"] as? String,
//                           let noteUUID = UUID(uuidString: noteID),
//                           let note = modelContext.fetch(Note.self, id: noteUUID) {
//                            noteToNavigate = note
//                        }
//                    }
//                }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let noteID = userInfo["noteID"] as? String {
            // Handle navigation to the specific note
            NotificationCenter.default.post(name: .navigateToNote, object: nil, userInfo: ["noteID": noteID])
        }
        completionHandler()
    }
}

extension Notification.Name {
    static let navigateToNote = Notification.Name("navigateToNote")
}
