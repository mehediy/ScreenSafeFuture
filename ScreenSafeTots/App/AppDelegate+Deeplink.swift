//
//  AppDelegate+Deeplink.swift

//  Created by Md. Mehedi Hasan on 23/8/21.

//

import UIKit
import FirebaseCore
import Firebase
import FirebaseMessaging

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate+Deeplink: application:app:open:options: \(url.absoluteString)")

        //UIApplication.topViewController?.showAlert(message: "AppDelegate+Deeplink: application:app:open:options: \(url.absoluteString)")
        
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("Source Application = \(sendingAppID ?? "Unknown")")
        
        /*if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            print("AppDelegate+Deeplink: -------Dynamic link from opneurl:\(dynamicLink)" )
            AppDelegate.handleIncomingDynamicLink(dlink: dynamicLink)
            return true
        }*/
        
        if url.absoluteString.contains("ssf://") || url.absoluteString.contains("ssfapp") {
            AppDelegate.handleIncomingDeepLink(url: url)
            return true
        }
        
        return false
    }
    
    
    //MARK: Universal link, DeepLink and other type of launch
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("AppDelegate+Deeplink: application:application:continue:")
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        
        /*if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingUrl = userActivity.webpageURL {
            print("AppDelegate+Deeplink: -------Continue User Activity called with link: \(incomingUrl.absoluteString)")
            
            //UIApplication.topViewController?.showAlert(message: "AppDelegate+Deeplink: -------Continue User Activity called with link: \(incomingUrl.absoluteString)")
            
            //dynamicLinks
            let dynamicLinkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamiclink, error) in
                guard error == nil else {
                    print("AppDelegate+Deeplink: Dynamic link parsing error:\(error!.localizedDescription)")
                    return
                }
                if let dlink = dynamiclink {
                    AppDelegate.handleIncomingDynamicLink(dlink: dlink)
                }
            }
            
            //Deeplink + Universal link
            var deeplinkHandled: Bool = false
            print("AppDelegate+Deeplink: dynamicLinkHandled: \(dynamicLinkHandled) deeplinkHandled: \(deeplinkHandled)")
            
            return dynamicLinkHandled || deeplinkHandled
        }*/
        
        return false
    }
    
    
    //MARK:- Helpers
//    static func handleIncomingDynamicLink(dlink: DynamicLink) {
//
//        guard let url = dlink.url else {
//            print("AppDelegate+Deeplink: Dynamic link URL not found")
//            return
//        }
//
//        AppDelegate.handleIncomingDeepLink(url: url)
//    }
    
    static func handleIncomingDeepLink(url: URL) {
        
        guard let url = url as NSURL? else {
            print("AppDelegate+Deeplink: Deep link URL not found")
            return
        }
        
        print("AppDelegate+Deeplink: ------Handling Incoming DeepLink: \(url)")
        let baseURL = "https://screensafetots.kennesaw.edu/"
        let host: String = "https://screensafetots.kennesaw.edu/"
        if url.absoluteString?.contains(host) == true || url.absoluteString?.hasPrefix("screensafetots://") == true {
            DeepLinkManager.shared.handleDeepLink(deepLinkUrl: url)
        }
    }
}
