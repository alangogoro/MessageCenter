//
//  AppDelegate.swift
//  MessageCenter
//
//  Created by usr on 2023/2/18.
//

import UIKit
import FirebaseCore
import FirebaseMessaging


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        Task.detached { @MainActor in
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            switch settings.authorizationStatus {
            case .denied, .notDetermined:
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions)
            case .authorized:
                application.registerForRemoteNotifications()
            default:
                break
            }
        }
        application.registerForRemoteNotifications()
        
        // MARK: Firebase
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Messaging.messaging().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo["gcmMessageID"] {
            Logger.debug("message ID: \(messageID)")
        }
        
        Logger.warning("userInfo:", userInfo)
        
        if UIApplication.shared.applicationState != .active {
            return [[.alert, .sound, .badge]]
        } else {
            if #available(iOS 14.0, *) {
                return [[.banner, .sound]]
            } else {
                return [[.alert, .sound]]
            }
            
            // show banner or navigate to..
        }
    }
    
    /// Handle opening push notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        // Remove deliverd notifications
        Task {
            let notifications = await center.deliveredNotifications()
            let identifiers = notifications.map { $0.request.identifier }
            center.removeDeliveredNotifications(withIdentifiers: identifiers)
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo["gcmMessageID"] {
            debugPrint("messageID = \(messageID)")
        }
        
        // Navigate to.. or get Call
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        #if DEBUG
        Messaging.messaging().subscribe(toTopic: "MC_test") { error in
            debugPrint("subscribed to MC_test topic")
        }
        #endif
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("Error:", error)
    }
    
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil,
                                        userInfo: tokenDict)
        Messaging.messaging().token { (token, error) in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                Logger.info("FCM registration token: \(token)")
            }
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated
    }
    
    /// Handle silent push notifications
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        if let messageID = userInfo["gcmMessageID"] {
            Logger.debug("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        return .newData
    }
    
}
