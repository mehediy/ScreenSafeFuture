//
//  AppManager.swift

//  Created by Md. Mehedi Hasan on 22/9/20.
//

import UIKit


class AppManager {
    
    private init() {
        //Do some initialization
    }
    
    static let shared = AppManager()
    
    
    //MARK: - Stored Properties
    
    var submittedSurvey: Survey?

    /// use this variable for homescreen widget update
    //var homeScreenWidgetUpdated: Observable<HomeWidgetType?> = Observable(nil)
    
    //MARK: - Computed Properties
    
    var notificationPermission: Bool {
        set { UserDefaults.standard.set(newValue, forKey: "PushNotificationPermission") }
        get { return UserDefaults.standard.bool(forKey: "PushNotificationPermission") }
    }
    
    
    var reminderPermission: Bool {
        set { UserDefaults.standard.set(newValue, forKey: "AppReminderPermission") }
        get { return UserDefaults.standard.bool(forKey: "AppReminderPermission") }
    }

    
    
}
