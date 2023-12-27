//
//  LearningResource.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/11/23.
//

import Foundation

enum LearningResourceType: String, Codable, CaseIterable {
    case all
    case website
    case pdf
    case video
    
    init?(intValue: Int) {
        switch intValue {
        case 0:
            self = .all
        case 1:
            self = .website
        case 2:
            self = .pdf
        case 3:
            self = .video
        default:
            return nil
        }
    }
    
    var imageName: String {
        switch self {
        case .website:
            return "link"
        case .pdf:
            return "doc.text"
        case .video:
            return "film"
        case .all:
            return ""
        }
    }
    
    var title: String {
        
        switch self {
        case .all:
            return "View All"
        case .website:
            return "Website"
        case .pdf:
            return "PDF"
        case .video:
            return "Video"

        }
    }
}


struct LearningResource: Codable {
    let type: LearningResourceType
    let title: String
    let objective: String
    let link: String
}

struct LearningResourceResponse: Codable {
    let learningResources: [LearningResource]
}
