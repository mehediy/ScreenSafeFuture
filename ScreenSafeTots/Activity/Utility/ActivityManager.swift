//
//  ActivityManager.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/9/23.
//

import Foundation


class ActivityManager {
    
    //MARK: - Stored Properties
    var submittedSurvey: Survey?
    private var unsortedActivities: [Activity]?
    private var sortedActivities: [Activity]?
    private var sortedWeightedActivities: [(activity: Activity, weight: Int)] = []
    

    static let shared = ActivityManager()
    
    private init() {
        //Do some initialization
        sortAllActivities()
    }
    
    /// use this variable for homescreen widget update
    //var homeScreenWidgetUpdated: Observable<HomeWidgetType?> = Observable(nil)
    
    //MARK: - Computed Properties
    
    static var QuestionarySurveryEvent: QuestionnaireEvent {
        set {
            UserDefaultsStore<Int>.questionarySurveryEvent.intValue = newValue.rawValue
        }
        get {
            guard let value = UserDefaultsStore<Int>.questionarySurveryEvent.intValue else { return .notSubmitted }
            return QuestionnaireEvent(rawValue: value) ?? .notSubmitted
        }
    }
    
    var questionnaireSubmitted: Bool {
        return ActivityManager.QuestionarySurveryEvent == .submitted
    }
    
    var allSortedActivities: [Activity] {
        if let sortedActivities = sortedActivities {
            return sortedActivities
        }
        return []
    }
    
    var favoriteActivities: [Activity] {
        return allSortedActivities.filter({ $0.isFavorite })
    }
    
    var topActivity: Activity? {
        
        guard let sortedActivities = sortAllActivities(force: false) else { return nil }
        
        //Filter out activities that is not applicable for today.
        let currentSortedActivities = sortedActivities.filter { activity in
            
            guard activity.isMatched else { return false }
            
            let today = Date()
            let yearInt = today.component(.year)!
            
            guard let startDate = Date(fromString: activity.timelineStart, format: .isoDate) else { return false }
            let adjustedStartDate = startDate.update(.year, value: yearInt).adjust(hour: 0, minute: 0, second: 1)
            
            if let timelineEnd = activity.timelineEnd, let endDate = Date(fromString: timelineEnd,  format: .isoDate) {
                
                let offset =  endDate.component(.year)! - startDate.component(.year)!
                let adjustedEndDate = endDate.update(.year, value: yearInt).adjust(.year, offset: offset).adjust(hour: 23, minute: 59, second: 59)
                
                if (min(adjustedStartDate,adjustedEndDate)...max(adjustedStartDate,adjustedEndDate)).contains(today) {
                    return true
                }
            } else if adjustedStartDate.compare(.isToday) {
                return true
            }
            
            return false
        }
        
        return currentSortedActivities.first
    }
    

    
    /// This function returns the sorted activities. if the excludeNonMatching is `false`, then it sorts all the available activities and return them.
    /// if the value of excludeNonMatching is `true`, then it returns only mathced activitiies in sorted order.
//    func getSortedActivities(excludeNonMatching: Bool = false) -> [Activity]? {
    @discardableResult
    func sortAllActivities(force: Bool = true) -> [Activity]? {

        if !force && sortedActivities != nil {
            return sortedActivities!
        }

        guard ActivityManager.QuestionarySurveryEvent == .submitted else { return nil }
        
        guard let survery = {
            if let submittedSurvey = submittedSurvey {
                return submittedSurvey
            } else {
                let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled.json")
                guard let loadedSurvey = try? Survey.LoadFromFile(url: jsonUrl) else { return nil }
                self.submittedSurvey = loadedSurvey
                return loadedSurvey
            }
        }() else { return nil }


        guard let activities = {
            if let activities = self.unsortedActivities {
                return activities
            } else {
                if let activitiyResponse: ActivityResponse = AppUtility.loadJson(filename: "activities") {
                    self.unsortedActivities = activitiyResponse.activities
                    return activitiyResponse.activities
                } else {
                    return nil
                }
            }
        }() else { return nil }

        
        let questionnaire = ActivityQuestionnaire(filledSurvey: survery)
        
        var weightedActivities: [(activity: Activity, weight: Int)] = []
        
        for var activity in activities {
            
            var totalWeight = 0
            
            //var shouldAdd = true
            var nonMatched = false
            
            // Handling activityType
            if activity.activityType == questionnaire.preferredActivityType || questionnaire.preferredActivityType == .indoorOutdoor {
                totalWeight += 10
            } else {
                nonMatched = true
            }
            
            // Handling ageRange
            //Order: thirtySixPlus > eighteen_thirtySix > zero_eighteen
            if activity.ageRange == .all || activity.ageRange == questionnaire.childAgeRange {
                totalWeight += 10
            } else if questionnaire.childAgeRange == .thirtySixPlus {
                if activity.ageRange == .eighteen_thirtySix {
                    totalWeight += 7
                } else if activity.ageRange == .zero_eighteen {
                    totalWeight += 5
                    nonMatched = true
                }
            } else if questionnaire.childAgeRange == .eighteen_thirtySix {
                if activity.ageRange == .zero_eighteen {
                    totalWeight += 7
                }
            }
            
            // Handling categories (can be multiple)
            //count of matching categories between questionnaire and activity
            let categoryMatches = questionnaire.preferredCategories.filter(activity.categories.contains).count
            if categoryMatches == 1 {
                totalWeight += 8
            } else if categoryMatches == 2 {
                totalWeight += 9
            } else if categoryMatches >= 3 {
                totalWeight += 10
            } else {
                nonMatched = true
            }
            
            // Handling ActivityDuration
            //Order: sixtyPlus > thirtyOne_sixty > zero_thirty
            if let activityDuration = activity.duration {
                if activityDuration <= questionnaire.parentAvailableDuration {
                    totalWeight += 10
                } else {
                    nonMatched = true
                }
            }

            // Handling parentSupervision
            //Order: constant > moderate > limited
            if let activitySupervision = activity.parentSupervision {
                if activitySupervision <= questionnaire.parentSupervision {
                    totalWeight += 10
                } else {
                    nonMatched = true
                }
            }
            
            // Handling parentSupervision
            //Order: veryDynamic > dynamic > lessDynamic
            if let activityDynamicityLevel = activity.dynamicityLevel {
                if activityDynamicityLevel == questionnaire.childDynamicityLevel {
                    totalWeight += 10
                } else if questionnaire.childDynamicityLevel == .veryDynamic {
                    if activityDynamicityLevel == .dynamic {
                        totalWeight += 7
                    } else if activityDynamicityLevel == .lessDynamic {
                        totalWeight += 5
                        nonMatched = true
                    }
                } else if questionnaire.childDynamicityLevel == .dynamic {
                    if activityDynamicityLevel == .lessDynamic {
                        totalWeight += 7
                    }
                }
            }
            
            // Handling Special Occasion
            if questionnaire.interestedInHolidays && activity.specialOccasion == true {
                totalWeight += 10
            }
            
            
            activity.isMatched = !nonMatched
            weightedActivities.append((activity: activity, weight: totalWeight))
            
            /*if excludeNonMatching {
                if shouldAdd {
                    weightedActivities.append((activity: activity, weight: totalWeight))
                }
            } else {
                weightedActivities.append((activity: activity, weight: totalWeight))
            }*/

        }
        
        var sortedWeightedActivitiesTemp = weightedActivities.sorted(by: {$0.weight > $1.weight})
        sortedWeightedActivitiesTemp.forEach { (activity, weight) in
            print("\(activity.name) :   \(weight)")
        }
        
        if questionnaire.interestedInHolidays {
            sortedWeightedActivitiesTemp.sort { $0.activity.specialOccasion && !$1.activity.specialOccasion }
        }
        
        self.sortedWeightedActivities = sortedWeightedActivitiesTemp
        let sortedActivities = sortedWeightedActivitiesTemp.map({ $0.activity })
        self.sortedActivities = sortedActivities
        return sortedActivities
    }
    
    
}
