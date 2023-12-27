//
//  AccomplishmentData.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit

struct AccomplishmentData {
    let activityProgress: Double
    let contentProgress: Double
    let timeTrackingProgress: Double
    
    
    
    var overallProgress: Double {
        return (activityProgress + contentProgress + timeTrackingProgress) / 3
    }
    
    var overallProgressLabel: String {
        return overallProgress.removeZerosFromEnd(maximumFractionDigits: 0) + "%"
    }
    
    var activityProgressLabel: String {
        return activityProgress.removeZerosFromEnd(maximumFractionDigits: 0) + "%"
    }
    
    var contentProgressLabel: String {
        return contentProgress.removeZerosFromEnd(maximumFractionDigits: 0) + "%"
    }
    
    var timeTrackingProgressLabel: String {
        return timeTrackingProgress.removeZerosFromEnd(maximumFractionDigits: 0) + "%"
    }
    
    
    var badgeImage: UIImage? {
        switch true {
        case overallProgress <= 35:
            return UIImage(named: "Badge_0-35")
        case (overallProgress > 35 && overallProgress <= 70):
            return UIImage(named: "Badge_36-70")
        case overallProgress > 70:
            return UIImage(named: "Badge_71-100")
        default:
            return nil
        }
    }
    
    var awardImage: UIImage? {
        switch true {
        case overallProgress <= 35:
            return UIImage(named: "Award_0-35")
        case (overallProgress > 35 && overallProgress <= 70):
            return UIImage(named: "Award_36-70")
        case overallProgress > 70:
            return UIImage(named: "Award_71-100")
        default:
            return nil
        }
    }
    
    var activityImageFirst: UIImage? {
        return activityProgress > 0 ? UIImage(named: "Activity_0-35") : nil
    }
    
    var activityImageSecond: UIImage? {
        return activityProgress > 35 ? UIImage(named: "Activity_36-70") : nil
    }
    
    var activityImageThird: UIImage? {
        return activityProgress > 70 ? UIImage(named: "Activity_71-100") : nil
    }
    
    
    var contentImageFirst: UIImage? {
        return contentProgress > 0 ? UIImage(named: "Content_0-35") : nil
    }
    
    var contentImageSecond: UIImage? {
        return contentProgress > 35 ? UIImage(named: "Content_36-70") : nil
    }
    
    var contentImageThird: UIImage? {
        return contentProgress > 70 ? UIImage(named: "Content_71-100") : nil
    }
    
    

    var timeTrackingImageFirst: UIImage? {
        return timeTrackingProgress > 0 ? UIImage(named: "TimeTracking_0-35") : nil
    }
    
    var timeTrackingImageSecond: UIImage? {
        return timeTrackingProgress > 35 ? UIImage(named: "TimeTracking_36-70") : nil
    }
    
    var timeTrackingImageThird: UIImage? {
        return timeTrackingProgress > 70 ? UIImage(named: "TimeTracking_71-100") : nil
    }
}
