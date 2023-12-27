//
//  CLLocationManager+Extensions.swift

//  Created by Md. Mehedi Hasan on 21/4/22.
//

import CoreLocation


//Hand picked from https://github.com/malcommac/SwiftLocation

// MARK: - CLAuthorizationStatus
//extension CLAuthorizationStatus: CustomStringConvertible {
extension CLAuthorizationStatus {
    
    internal var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    internal var isRejected: Bool {
        switch self {
        case .denied, .restricted:
            return true
        default:
            return false
        }
    }
    
//    public var description: String {
//        switch self {
//        case .notDetermined:            return "notDetermined"
//        case .restricted:               return "restricted"
//        case .denied:                   return "denied"
//        case .authorizedAlways:         return "always"
//        case .authorizedWhenInUse:      return "whenInUse"
//        @unknown default:               return "unknown"
//        }
//    }
    
}

// MARK: - CLLocationCoordinate2D
/*
extension CLLocationCoordinate2D: Codable {
   
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
     
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
    
}*/
