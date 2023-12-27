import UIKit
import SwiftUI

final class LoginCoordinator: NSObject, Coordinator {

    // MARK: - Properties

    private weak var window: UIWindow?

    var rootViewController: UINavigationController

    // MARK: - Lifecycle

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
        super.init()
    }

    // MARK: - Functions

    func start() {
        
        let loginContainerViewController = LoginContainerViewController(delegate: self)
        rootViewController.viewControllers = [loginContainerViewController]
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

    }
    

    
    private func openHomeScreen() {
        UIWindow.key?.rootViewController = AppHomeViewController()
    }
    
    private func openSurveyScreen() {
        var survey: Survey = SampleSurvey
        
        let jsonUrl = URL.documentsDirectory().appendingPathComponent("sample_survey.json")
        try? Survey.SaveToFile(survey: survey, url: jsonUrl)
        print( " Saved survey to: \n" , jsonUrl.path )
        
        if let loadedSurvey = try? Survey.LoadFromFile(url: jsonUrl) {
            print(" Loaded survey from:\n ", jsonUrl)
            survey = loadedSurvey
        }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = SurveyView(survey: survey, delegate: self).preferredColorScheme(.light)
        
        // Use a UIHostingController as window root view controller.
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
        
        
        // Add a tap gesture to the background to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window?.addGestureRecognizer(tapGesture)
        
        window?.makeKeyAndVisible()
    }
    
    func shouldShowSurvey() -> Bool {
        switch ActivityManager.QuestionarySurveryEvent {
        case .notSubmitted, .remindLater:
            return true
        case .submitted, .declined:
            return false
        }
    }
}

extension LoginCoordinator: LoginViewDelegate {
    
    func didLogin(_ login: UserLogin?) {
        print("\(String(describing: login?.email)) logged in.")
        
        if shouldShowSurvey() {
            openSurveyScreen()
        } else {
            self.openHomeScreen()
        }
    }
}


extension LoginCoordinator: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}


extension LoginCoordinator : SurveyViewDelegate {
    
    func surveyCompleted(with survey: Survey) {
        //let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled" + String(Int.random(in: 0...100)) + ".json")
        let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled.json")
        try? Survey.SaveToFile(survey: survey, url: jsonUrl)
        print( " Saved survey to: \n" , jsonUrl.path )
        
        ActivityManager.QuestionarySurveryEvent = .submitted
        openHomeScreen()
    }
    
    func surveyDeclined() {
        ActivityManager.QuestionarySurveryEvent = .declined
        openHomeScreen()
    }
    
    func surveyRemindMeLater() {
        ActivityManager.QuestionarySurveryEvent = .remindLater
        openHomeScreen()
    }
    
}
