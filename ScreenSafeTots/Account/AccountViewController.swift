//
//  AccountViewController.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit
import SwiftUI


class AccountViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }

    //let tableView: BaseTableView = BaseTableView.with {
    let tableView = with(UITableView(frame: .zero, style: .grouped)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(white: 245 / 255.0, alpha: 1.0)
        $0.separatorStyle = .none
        $0.register(SingleLineInfoCardCell.self)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 56.0
        //$0.contentInset.top = 4
        //$0.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        //$0.tableFooterView = UIView(frame: frame)
    }
    
    
    var isfirstTimeLoad: Bool = true
    
    private var accountSections: [AccountSection] = AccountSection.allCases
    private var showingSurveyVC: UIViewController?
    
    //MARK: - ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        setupView()
        
        //AnalyticsManager.shared.logEvent("In_app_messaging", parameters:nil)
        
        //update firebase token if any update
        //FirebaseService.updateFirebaseToken()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isfirstTimeLoad {
            isfirstTimeLoad = false
            tableView.addTopBackgroundView(viewColor: Theme.Color.primary)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
    }

    
    func setupData() {
        
        tableView.reloadData()
    }
    
    
    func setupView() {
        
        view.backgroundColor = UIColor(white: 245 / 255.0, alpha: 1.0)

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 38, right: 0)

        tableView.topAnchor == view.saferAreaLayoutGuide.topAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == view.bottomAnchor
    }
}


//MARK: Delegate, DataSource
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return accountSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = self.accountSections[safe: indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SingleLineInfoCardCell
        cell.configure(title: section.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handleCardViewSelection(indexPath: indexPath)
        
        if let section = self.accountSections[safe: indexPath.row]  {
            
            switch section {
            case .accomplishment:
                let AccomplishmentVC = AccomplishmentViewController()
                navigationController?.pushViewController(AccomplishmentVC, animated: true)
            case .survey:
                openSurveyScreen()
            case .logout:
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                DispatchQueue.main.async {
                    appDelegate.openLoginScreen()
                }
            default:
                break
            }
        }

        
    }
}



extension AccountViewController: SurveyViewDelegate, UIGestureRecognizerDelegate {
    
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
        let surveyViewHostingController = UIHostingController(rootView: contentView)
        surveyViewHostingController.modalPresentationStyle = .fullScreen
        navigationController?.present(surveyViewHostingController, animated: true)
        showingSurveyVC = surveyViewHostingController
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
    
    func surveyCompleted(with survey: Survey) {
        //let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled" + String(Int.random(in: 0...100)) + ".json")
        let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled.json")
        try? Survey.SaveToFile(survey: survey, url: jsonUrl)
        print( " Saved survey to: \n" , jsonUrl.path )
        
        showingSurveyVC?.dismiss(animated: false)
        ActivityManager.QuestionarySurveryEvent = .submitted
        ActivityManager.shared.submittedSurvey = survey
        ActivityManager.shared.sortAllActivities()
        
        (self.tabBarController as? MainTabBarController)?.reloadHomeActivity()
        setupData()
    }
    
    func surveyDeclined() {
        //ActivityManager.QuestionarySurveryEvent = .declined
        showingSurveyVC?.dismiss(animated: false)
    }
    
    func surveyRemindMeLater() {
        //ActivityManager.QuestionarySurveryEvent = .remindLater
        showingSurveyVC?.dismiss(animated: false)
    }
    
}
