//
//  RemoteConfigManager.swift

//  Created by Md. Mehedi Hasan on 21/9/21.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

extension RemoteConfigFetchStatus {
    var debugDescription: String {
        switch self {
        case .failure:
            return "failure"
        case .noFetchYet:
            return "pending"
        case .success:
            return "success"
        case .throttled:
            return "throttled"
        @unknown default:
            return "unknown"
        }
    }
}

enum RemoteConfigKey: String {
    case transactionMinRefreshTime = "transaction_min_refresh_time"
    case gpEmployeeMaxCashinAmount = "gpemployee_max_cashin_amount"
    case billpaymentQuickSelectionAmounts = "billpayment_quick_selection_amounts"
    case cashinQuickSelectionAmounts = "cashin_quick_selection_amounts"
    case pendingBillMaxReminder = "pendingbill_max_reminder"
    case mobileRechargeMinimumAmount = "mobile_recharge_minimum_amount"
}

class RemoteConfigManager {
    
    static let ConfigStale = "REMOTE_CONFIG_STALE"
    
    // MARK: Properties
    static let shared = RemoteConfigManager()
    let remoteConfig: RemoteConfig
    fileprivate var expirationDuration: Double = 43200 // 12 hours in seconds.
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    

    private init() {
        //FirebaseApp.configure()
        self.remoteConfig = RemoteConfig.remoteConfig()
        self.configureDefaults()
        self.configureSettings()
        self.fetchRemoteValues(completionHandler: nil)
    }
    
    
    // MARK: Public
    
    func color(forKey key: RemoteConfigKey) -> UIColor {
        let colorAsHexString = remoteConfig[key.rawValue].stringValue ?? "#FFFFFFFF"
        let convertedColor = UIColor(colorAsHexString)
        return convertedColor
    }
    
    func bool(forKey key: RemoteConfigKey) -> Bool {
        remoteConfig[key.rawValue].boolValue
    }
    
    func string(forKey key: RemoteConfigKey) -> String {
        remoteConfig[key.rawValue].stringValue ?? ""
    }
    
    func double(forKey key: RemoteConfigKey) -> Double {
        remoteConfig[key.rawValue].numberValue.doubleValue
    }
    
    func float(forKey key: RemoteConfigKey) -> Float {
        remoteConfig[key.rawValue].numberValue.floatValue
    }
    
    func integer(forKey key: RemoteConfigKey) -> Int {
        remoteConfig[key.rawValue].numberValue.intValue
    }
    
    func array<T: Decodable>(forKey key: RemoteConfigKey) -> [T] {
        //remoteConfig[key.rawValue].jsonValue as? [T] ?? []
        let jsonData = remoteConfig[key.rawValue].dataValue
        do {
            return try JSONDecoder().decode([T].self, from: jsonData)
        } catch {
            return []
        }
    }
    
    
    // MARK: Private
    fileprivate func configureDefaults() {
        
        let defaultValues: [String: Any?] = [
            RemoteConfigKey.transactionMinRefreshTime.rawValue: 30,
            RemoteConfigKey.gpEmployeeMaxCashinAmount.rawValue: 20000,
            RemoteConfigKey.billpaymentQuickSelectionAmounts.rawValue: [500, 1000, 490, 480, 485, 980, 300, 290, 200, 190],
            RemoteConfigKey.cashinQuickSelectionAmounts.rawValue: [100, 300, 500, 1000, 1500, 2000, 3000, 5000, 8000, 10000],
            RemoteConfigKey.pendingBillMaxReminder.rawValue: 30,
            RemoteConfigKey.mobileRechargeMinimumAmount.rawValue: 20,
        ]
        remoteConfig.setDefaults(defaultValues as? [String : NSObject])
    }
    
    fileprivate func configureSettings() {
        
        if UserDefaults.standard.bool(forKey: RemoteConfigManager.ConfigStale) {
            expirationDuration = 0
            UserDefaults.standard.set(false, forKey: RemoteConfigManager.ConfigStale)
        }
        
        //FIXME:- Don't actually do this in production!
        //activateDebugMode()
        //expirationDuration = 0
    }
    
    fileprivate func activateDebugMode() {
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    
    func fetchRemoteValues(completionHandler: (() -> Void)?) {
        
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
            
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                // In a real app, you would probably want to call the loading done callback anyway,
                // and just proceed with the default values. I won't do that here, so we can call attention
                // to the fact that Remote Config isn't loading.
                print(error.localizedDescription)
                print(status.debugDescription)
                return
            }
            
            RemoteConfig.remoteConfig().activate { [weak self] _, _ in
                print("Fetched values from remote!")
                self?.fetchComplete = true
                DispatchQueue.main.async {
                    self?.loadingDoneCallback?()
                    completionHandler?()
                }
            }
        }
    }
}
