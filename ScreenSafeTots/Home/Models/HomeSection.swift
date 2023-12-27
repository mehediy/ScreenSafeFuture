//
//  HomeSection.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 9/28/23.
//

import Foundation


enum HomeSection: Int, CaseIterable, Codable {
    
    case activity
    
    case accomplishment

//    case screenTime
    
    case learningResource
    
    case favoriteAcitivity
    
    var title: String {
        switch self {
        case .activity:
            return "Today's Activity"
        case .favoriteAcitivity:
            return "Favorite Activity"
//        case .screenTime:
//            return "Screen Time"
        case .learningResource:
            return "More ways to Learn"
        case .accomplishment:
            return "Your Accomplishments"
        }
    }
    
    var rowCount: Int {
        switch self {
        case .activity:
            return 1
        case .favoriteAcitivity:
            return 1
//        case .screenTime:
//            return 1
        case .learningResource:
            return 1
        case .accomplishment:
            return 1
        }
    }
    
}
