//
//  AppDelegate+Notification.swift

//  Created by Md. Mehedi Hasan on 23/8/21.

//

import UIKit
import Foundation
import UserNotifications
import FirebaseMessaging



extension AppDelegate {
    
    //MARK: Remote Notification
    /*
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        
        if application.applicationState == .active || application.applicationState == .background {
            // Call when app is in foreground
        } else {
            // Call when app is in background/Not Running/when the user responded to the notification
        }
        
        print("AppDelegate+Notification: didReceiveRemoteNotification: \(userInfo)")
        
        if let urlString = userInfo[Constants.App.deepLinkKey] as? String, let deepLinkUrl = URL(string: urlString) {
            AppDelegate.handleIncomingDeepLink(url: deepLinkUrl)
        }
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print("AppDelegate+Notification: didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
        
        if let urlString = userInfo[deepLinkKey] as? String, let deepLinkUrl = URL(string: urlString) {
            AppDelegate.handleIncomingDeepLink(url: deepLinkUrl)
        }
        
        completionHandler(UIBackgroundFetchResult.noData)
    }
    */
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("AppDelegate+Notification: didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }
    
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("AppDelegate+Notification: didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        //Messaging.messaging().apnsToken = deviceToken
    }
    
    
    //MARK:- Helpers
    
    func registerForNotifications(application: UIApplication) {

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print(granted ? "AppDelegate+Notification: permision granted!🙂" : "AppDelegate+Notification: permision not granted!🙁")
            AppManager.shared.notificationPermission = granted
        }
        
        application.registerForRemoteNotifications()
    }
}



// Receive displayed notifications for iOS 10 devices.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Call when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        //Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print("AppDelegate+Notification: userNotificationCenter:willPresent: \(userInfo)")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("AppDelegate+Notification: Message ID: \(messageID)")
        }
        
        
        //propagate remote config updates in real time
        if let _ = userInfo[RemoteConfigManager.ConfigStale] as? String {
            UserDefaults.standard.set(true, forKey: RemoteConfigManager.ConfigStale)
        }
        //NotificationCenter.default.post(name: .init(RemoteConfigManager.ConfigStale), object: nil, userInfo: userInfo)
        
        
        // Change this to your preferred presentation option
        //completionHandler([])
        completionHandler([.alert, .sound])
    }
    
    
    // Call when app is in background/Not Running/when the user responded to the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        print("AppDelegate+Notification: userNotificationCenter:didReceive: \(userInfo)")
        if let messageID = userInfo[gcmMessageIDKey] {
            print("AppDelegate+Notification: Message ID: \(messageID)")
        }
        
        
        //propagate remote config updates in real time
        if let _ = userInfo[RemoteConfigManager.ConfigStale] as? String {
            UserDefaults.standard.set(true, forKey: RemoteConfigManager.ConfigStale)
        }
        
        
        if let urlString = userInfo["deepLinkUrl"] as? String, let deepLinkUrl = URL(string: urlString) {
            AppDelegate.handleIncomingDeepLink(url: deepLinkUrl)
        }
        
        completionHandler()
    }
}
