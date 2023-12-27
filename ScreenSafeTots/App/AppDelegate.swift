import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
//import FBSDKCoreKit
//import GoogleSignIn

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //lazy var window: UIWindow? = .init()
    private var loginCoordinator: LoginCoordinator?
    
    var appJustLaunched:Bool = false
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    /// Used to complete Firebase DynamicLink in background to avoid random error. (Reference: )
    internal var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let keyWindow: UIWindow?
        if #available(iOS 13, *) {
            keyWindow = application.windows.first { $0.isKeyWindow }
        } else {
            keyWindow = application.keyWindow
        }
        self.window = keyWindow ?? UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        appJustLaunched = true
        if isFirstLaunchEver {
            setupAppForFirstLaunch()
        }
        
        openLoginScreen()
    
        ReachabilityManager.shared.startListening()
        
        FirebaseApp.configure()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication,
//                     configurationForConnecting connectingSceneSession: UISceneSession,
//                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(
//            name: "Default Configuration",
//            sessionRole: connectingSceneSession.role
//        )
//    }
//
//    // MARK: - Application Appearance
//    private func configureApplicationAppearance() {
//        //UINavigationBar.appearance().tintColor = .systemOrange
//        //UITabBar.appearance().tintColor = .systemOrange
//    }
    
}

extension AppDelegate {
    
    func openLoginScreen() {
        let window = self.window ?? UIWindow(frame: UIScreen.main.bounds)
        loginCoordinator = LoginCoordinator(window: window)
        loginCoordinator?.start()
        
//        let loginVC = LoginViewController.instantiate()
//        let navVC = MainNavigationController(rootViewController: loginVC)
//
//        self.window?.rootViewController = navVC
//        self.window?.makeKeyAndVisible()
    }
    
    var isFirstLaunchEver: Bool {
        if !UserDefaults.standard.bool(forKey: "AppHasLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "AppHasLaunchedOnce")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    func setupAppForFirstLaunch() {
        AppManager.shared.reminderPermission = true
    }
}


