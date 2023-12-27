//
//  DeepLinkManager.swift


import Foundation
import UIKit

class DeepLinkManager {
    
    //MARK: - Properties
    static let shared = DeepLinkManager()
    private var activeDeepLink: NSURL?
    private var activeDestination: DeepLinkDestination? = .none
    private var activeDeepLinkPathComponents: [String]?
    //private var activeDeepLinkParams : [String:String]?
    
    var shouldInitiateGuestModeAsSessionIsNotActive: Bool {
        return false
    }
    
    private init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
            //DeepLinkManager.shared.processDestination(viewcontroller: self)
            print("DidBecomeActive")
        }
    }
    
    //MARK: - Public Helpers
    
    /// Handle deeplink after parsing path components from url.
    /// Currently query params are not supported!
    ///- Example: for URL "foo://name.com:8080/12345?foo=1&baa=2",
    /**
     - scheme: foo
     - host: name.com
     - port: 8080
     - path: /12345
     - path components: (
         "/",
         12345
     )
     - query: foo=1&baa=2
     */
    public func handleDeepLink(deepLinkUrl: NSURL) {
        activeDeepLink = deepLinkUrl
        //activeDeepLinkParams = self.getQueryStringParams(deepLinkUrl)
        
        if deepLinkUrl.absoluteString?.hasPrefix("ssf://") == true  {
            
            if let host = deepLinkUrl.host, var pathComponents = deepLinkUrl.pathComponents, pathComponents.count > 0 {
                //replace first "/" by the host
                pathComponents[0] = host
                let queryParams = self.getQueryStringParams(deepLinkUrl)
                
                activeDestination = DeepLinkDestination(for: pathComponents, queryParams: queryParams)
                activeDeepLinkPathComponents = pathComponents
            }
            
        } else {
            
            //Example: 3 components ["/", "mfs", "walletrechage"] for "https://www.kennesaw.edu/walletrechage"
            if let pathComponents = deepLinkUrl.pathComponents, pathComponents.count > 2 {
                //remove first 2 ("/", "mfs")
                let adjustedPathComponents = Array(pathComponents.dropFirst(2))
                let queryParams = self.getQueryStringParams(deepLinkUrl)
                
                activeDestination = DeepLinkDestination(for: adjustedPathComponents, queryParams: queryParams)
                activeDeepLinkPathComponents = adjustedPathComponents
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) { [unowned self] in
            self.bringProperScreenToFront()
        }
    }
    
    public func handleDeepLink(destination: DeepLinkDestination, waitingInterval: DispatchTimeInterval = .milliseconds(200), sourceViewController: UIViewController? = nil) {
        //activeDeepLink = deepLinkUrl
        activeDestination = destination
        //activeDeepLinkPathComponents = pathComponents
        //activeDeepLinkParams = self.getQueryStringParams(deepLinkUrl)
        
        if let sourceViewController = sourceViewController {
            self.processDestination(from: sourceViewController)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + waitingInterval) { [unowned self] in
                self.bringProperScreenToFront()
            }
        }
    }
    
    /// check existing deeplink and perform action
    public func checkDeeplink(for viewController: UIViewController) {
        guard let activeDestination = activeDestination else { return }
        switch activeDestination {
        case .home: break
//            if viewController is HomeViewController {
//                processDestination(from: viewController)
//            } else {
//                bringProperScreenToFront()
//            }
        default: break
            
        }
    }
    
    //MARK: - Private Helpers
    
    ///this brings the app to the proper place/screen, from where the deeplink content is shown or forwared via viewDidLoad/Other methods.
    private func bringProperScreenToFront() {
        
        //let topVC = AppManager.getTopViewController()
        //let isSessionActive = UserSessionManager.shared.isSessionActive()
        
        switch self.activeDestination {
        
        case .home: break
//            if shouldInitiateGuestModeAsSessionIsNotActive {
//                UserSessionManager.shared.guestModeInitiated(true)
//                UIApplication.setRootView(AppHomeViewController())
//                break
//            } else if topVC?.isKind(of: HomeViewController.self) == false {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationNames.K_CHANGE_HOME_TAB),
//                                                object: nil, userInfo: ["tabNumber" : 0, "popToRoot" : "true"])
//            } else {
//                if let topVC = topVC {
//                    self.processDestination(from: topVC)
//                }
//            }
        case .none: break
        default: break
            
        }
    }
    
    ///called when  the proper screen is in front, and from where view's are pushed to show the deeplink content
    private func processDestination(from viewController: UIViewController) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(450)) { [unowned self] in
            
            switch self.activeDestination {
            case .home: break
//                if viewController is HomeViewController {
//                    self.deepLinkHandledSuccessfully()
//                }
                
            case .none:
                print(".None, Nothing here to execute as deep link.")
            default: break
            }
        }
    }
    
    private func deepLinkHandledSuccessfully() {
        self.activeDeepLink = nil
        self.activeDeepLinkPathComponents = nil
        self.activeDestination = .none
        //self.activeDeepLinkParams = nil
    }
    
    /// Get all the query aparams patesed in dictionary object
    ///- Example: for URL  https://www.kennesaw.edu/walletrechage?type=cards&value=1000 return  ["type": "cards", "value": "1000"]
    ///- parameter forUrl: for the url the query params need to be listed
    ///- returns:Dictionary  of a key:value pairs
    private func getQueryStringParams(_ forUrl:NSURL) -> [String:String] {
        guard let urlString = forUrl.absoluteString else {
            print("url is invalid")
            return [:]
        }
        
        if let url = URL(string: urlString) {
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            var queryParams = [String: String]()
            if let queryItems = urlComponents?.queryItems {
                for queryItem: URLQueryItem in queryItems {
                    if queryItem.value == nil {
                        continue
                    }
                    queryParams[queryItem.name] = queryItem.value
                }
                return queryParams
            }
        }
        //nothing here, return empty
        return [:]
    }
}
