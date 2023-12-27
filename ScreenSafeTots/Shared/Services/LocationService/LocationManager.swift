//
//  LocationManager.swift
//
//  Created by Md. Mehedi Hasan on 21/4/22.
//

import CoreLocation

enum AuthorizationMode: Int {
    case always
    case whenInUse
}

enum LocationAuthorizationStatus: Equatable {
    case disabled
    case notDetermined
    case notAuthorized
    case authorized(mode: AuthorizationMode)
    case unknown
    
    var isAuthorized: Bool {
        switch self {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .disabled:
            return "Locations Services is turned off. Please turn it on in Settings"
        case .notDetermined:
            return "Location permision is not determined yet"
        case .notAuthorized:
            return "Location permision is not given. Pleasee allow location access for this app"
        case .authorized( _):
            //return "Location permision is authorized"
            return nil
        case .unknown:
            return "Some unknown error occurred"
        }
    }
}

protocol LocationManagerDelegate: AnyObject {
    func locationDidChangeAuthorization(status: CLAuthorizationStatus)
    func locationManager(didFailWithError error: Error)
    func locationManager(didReceiveLocations locations: [CLLocation])
}


final class LocationManager: NSObject {
    
    private override init() {
        super.init()
        
        setupManager()
    }
    
    static let shared = LocationManager()
    
    private var manager: CLLocationManager = CLLocationManager()
    
    private var authorizationCallback: ((LocationAuthorizationStatus) -> Void)?
    
    /// Delegate of events
    weak var delegate: LocationManagerDelegate?
    /// Location updates
    var continousLocation: Bool = false {
        didSet {
            if continousLocation {
                startUpdatingLocation()
            } else {
                stopUpdatingLocation()
                manager.requestLocation()
            }
        }
    }
    
    
    /// Setup location manager
    func setupManager() {
        //manager = nil
        //manager = CLLocationManager()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = false
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 20
        //manager.activityType = .other
    }
    
    
    ///Destroy location manager
    func destroyLocationManager() {
        stopUpdatingLocation()
        manager.delegate = nil
        //manager = nil
        //lastKnownLocation = nil
    }

    
    /// Ask for authorization.
    /// - Parameter mode: style.
    func requestAuthorization(_ mode: AuthorizationMode = .whenInUse, callback: ((LocationAuthorizationStatus) -> Void)?) {
        
        guard authorizationStatus.isAuthorized == false else {
            startUpdatingLocation()
            callback?(authorizationStatus)
            return
        }
        
        if callback != nil {
            authorizationCallback = callback
        }
        
        switch mode {
        case .always:
            manager.requestAlwaysAuthorization()
        case .whenInUse:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    /// Starts updating location
    func startUpdatingLocation() {
        if continousLocation {
            manager.startUpdatingLocation()
        } else {
            manager.requestLocation()
        }
    }
    
    
    /// Stops updating location
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
      switch status {
//      case .notDetermined:
//          requestAuthorization(callback: nil)
      case .authorizedAlways, .authorizedWhenInUse:
          startUpdatingLocation()

      default:
          break
      }
    }
    
    
    private func didChangeAuthorizationStatus(_ newStatus: CLAuthorizationStatus) {
    
        print("didChangeAuthorizationStatus: \(newStatus)")
        guard newStatus != .notDetermined else {
            return
        }
        
        handleAuthorizationStatus(newStatus)
        
        authorizationCallback?(locationAuthorizationStatus(from: newStatus))
        authorizationCallback = nil
        delegate?.locationDidChangeAuthorization(status: newStatus)
    }
    
    
    // MARK: - Properties
    
    var lastLocationObervable: Observable<CLLocation?> = Observable(nil)
    //var authorizationStatusObervable: Observable<LocationAuthorizationStatus> = Observable(.notAuthorized)

    /// The status of the authorization manager.
    var authorizationStatus: LocationAuthorizationStatus {
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                status = manager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            return locationAuthorizationStatus(from: status)
            
        } else {
            return .disabled
        }
    }
    
    func locationAuthorizationStatus(from status: CLAuthorizationStatus) -> LocationAuthorizationStatus {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied:
            return .notAuthorized
        case .authorizedAlways:
            return .authorized(mode: .always)
        case .authorizedWhenInUse:
            return .authorized(mode: .whenInUse)
        @unknown default:
            return .unknown
        }
    }
    
    
    /// Last known gps location.
    var lastKnownLocation: CLLocation? {
        get {
            guard let data = UserDefaults.standard.object(forKey: "location-manager.last-gps-location") as? Data else {
                return nil
            }
            
            let location = NSKeyedUnarchiver.unarchiveObject(with: data) as? CLLocation
            return location
        }
        set {
            guard let location = newValue else {
                UserDefaults.standard.removeObject(forKey: "location-manager.last-gps-location")
                return
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject: location)
            UserDefaults.standard.setValue(data, forKey: "location-manager.last-gps-location")
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            didChangeAuthorizationStatus(manager.authorizationStatus)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // This method is called only on iOS 13 or lower, for iOS14 we are using `locationManagerDidChangeAuthorization` below.
        didChangeAuthorizationStatus(status)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
        delegate?.locationManager(didFailWithError: error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("didUpdateLocations: \(locations)")
        guard let lastLocation = locations.max (by: { $0.timestamp > $1.timestamp }) else {
            return
        }
        
        lastKnownLocation = lastLocation
        lastLocationObervable.value = lastLocation
        delegate?.locationManager(didReceiveLocations: locations)
    }
}

