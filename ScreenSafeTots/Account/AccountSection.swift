//
//  AccountSection.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/15/23.
//

import Foundation

enum AccountSection: Int, CaseIterable, Codable {

    case profile
    
    case accomplishment
    
    case survey
    
    case leaderboard
    
    case contactUs
    
    case aboutUs
    
    case changePassword
    
    case logout
    
    
    var title: String {
        switch self {
        case .profile:
            "Edit Profile"
        case .accomplishment:
            "See All Accomplishment"
        case .survey:
            "Submit Survey"
        case .leaderboard:
            "Leaderboard"
        case .contactUs:
            "Contact Us"
        case .aboutUs:
            "Abous Us"
        case .changePassword:
            "Change Password"
        case .logout:
            "Log Out"
        }
    }
}
