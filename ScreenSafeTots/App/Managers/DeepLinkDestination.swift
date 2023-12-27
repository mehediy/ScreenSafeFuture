//
//  DeepLinkDestination.swift

//  Created by Md. Mehedi Hasan on 2/8/21.
//

import Foundation


enum DeepLinkDestination: Equatable {
    ///https://screensafetots.kennesaw.edu/home
    case home
    
    ///https://screensafetots.kennesaw.edu/more
    case more
    
    ///https://screensafetots.kennesaw.edu/more/profile
    case profile
    
    ///https://screensafetots.kennesaw.edu/more/tutorial
    case tutorial

    
    init?(for pathComponents: [String]?, queryParams: [String: String]?) {
        guard let pathComponents = pathComponents, let target = pathComponents.first else { return nil }
        
        var deepLinkDestination: DeepLinkDestination?

        if target == "home" {
            deepLinkDestination = .home
        } else if target == "more" {
            switch pathComponents[safe: 1] {
            case "tutorial":
                deepLinkDestination = .tutorial
            default:
                deepLinkDestination = .more
            }
        } else if target == "profile" {
            deepLinkDestination = .profile
        }
        
        if let deepLinkDestination = deepLinkDestination {
            self = deepLinkDestination
        } else {
            return nil
        }
    }
    
}
