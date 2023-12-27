//
//  HomeViewController.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 9/13/23.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    lazy var inboxBadgedButton: BadgedButton = {
        let button = BadgedButton(image: UIImage(named: "icon_mail_mono")) {
            //self.inboxButtonTapped()
        }
        button.badgeTintColor = Theme.Color.redRibbon
        return button
    }()
    
    let topContainerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    var topContainerViewHeightLC: NSLayoutConstraint!
    
    //let tableView: BaseTableView = BaseTableView.with {
    let tableView = with(UITableView(frame: .zero, style: .grouped)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white //Theme.Color.background
        $0.separatorStyle = .none
        $0.register(TableViewCell<InfoCardView>.self)
        $0.register(TableViewCell<InfoListView>.self)
        $0.register(TableViewCell<LearnView>.self)
        $0.register(TableViewCell<OverallProgressView>.self)
        //        $0.register(ButtonTableCell.self)
        $0.register(HeaderFooterHolderView<HomeHeaderView>.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 150
        //$0.contentInset.top = 4
        //$0.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        //$0.tableFooterView = UIView(frame: frame)
    }
    
    var isfirstTimeLoad: Bool = true
    
    ///use this array as datasource for tableview
    private var homeSections: [HomeSection] = HomeSection.allCases
    
    private var topActivityInfoData: InfoCardData?
    private var topActivity: Activity?
    private var favoriteActivities: [Activity] = []
    
    private var showingSurveyVC: UIViewController?
    
    //var storedWidgets: [HomeWidgetModel] = UserDefaultsStore<HomeWidgetModel>.homeWidget.arrayValue ?? []
    
    //MARK: - ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
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
    
    //MARK: - UI Helpers
    
    //    private func getRightBarButtonItems(inboxBadgeCount: Int? = nil) -> [UIBarButtonItem]? {
    //        inboxBadgedButton.badgeNumber = inboxBadgeCount
    //
    //        let inboxBadgedButtonItem = UIBarButtonItem(customView: inboxBadgedButton)
    //        let searchLeftBarItem = UIBarButtonItem.init(image: UIImage(named: "icon_search_mono"), style: .plain, target: self, action: #selector(searchTapped))
    //        searchLeftBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
    //        return [inboxBadgedButtonItem, searchLeftBarItem]
    //    }
    //
    
    
    private func setupNavBar() {
        
        
        //self.title = "ScreenSafeTots"
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        rightBarItem.setTitleTextAttributes([.font: Theme.Font.medium.withSize(18)], for: .normal)
        rightBarItem.setTitlePositionAdjustment(UIOffset(horizontal: 0.0, vertical: 5.0), for: .default)
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setupData() {
        
        if ActivityManager.shared.questionnaireSubmitted {
            let activity = ActivityManager.shared.topActivity
            if let activity = activity {
                topActivity = activity
                topActivityInfoData = InfoCardData(title: activity.name, subtitle: activity.explanation)
            } else {
                topActivityInfoData = InfoCardData(title: "You haven't submitted survey yet", subtitle: "Submit survey to get personalized activity suggestion")
            }
        } else {
            topActivityInfoData = InfoCardData(title: "You haven't submitted survey yet", subtitle: "Submit survey to get personalized activity suggestion")
        }
        
        
        self.favoriteActivities = ActivityManager.shared.favoriteActivities
        
        tableView.reloadData()
        let InfoListViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: HomeSection.favoriteAcitivity.rawValue))
        (InfoListViewCell as? TableViewCell<InfoListView>)?.customView.collectionView.reloadData()
    }
    
    
    func setupView() {
        
        view.backgroundColor = .white
        
        setupNavBar()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 38, right: 0)
        //tableView.register(SortFilterHeaderView.self)
        
        view.addSubview(topContainerView)
        topContainerViewHeightLC = topContainerView.heightAnchor == 0
        
        topContainerView.topAnchor == view.saferAreaLayoutGuide.topAnchor
        topContainerView.horizontalAnchors == view.horizontalAnchors
        
        tableView.topAnchor == topContainerView.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.bottomAnchor == view.bottomAnchor
    }
    
    @objc func searchTapped() {
        
    }
    
    
    func handleActivitySelection(_ activity: Activity) {
        let activityDetailVC = ActivityDetailViewController()
        activityDetailVC.activity = activity
        navigationController?.pushViewController(activityDetailVC, animated: true)
    }
    
    func handleLearnEventSelection(_ eventType: LearningResourceType) {
        (tabBarController as? MainTabBarController)?.goToResources(type: eventType)
    }
    
    func handleAccomplishmentSelection() {
        let AccomplishmentVC = AccomplishmentViewController()
        navigationController?.pushViewController(AccomplishmentVC, animated: true)
    }

}


//MARK: Delegate, DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let homeSection = self.homeSections[safe: section] else {
            return 1
        }
        return homeSection.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let homeSection = self.homeSections[safe: indexPath.section] else {
            return UITableViewCell()
        }
        
        switch homeSection {
        case .activity:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<InfoCardView>
            if let infoData = topActivityInfoData {
                cell.customView.configure(data: infoData)
            }
            return cell

        case .favoriteAcitivity:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<InfoListView>
            cell.customView.configure(activities: favoriteActivities) { [weak self] (activity) in
                self?.handleActivitySelection(activity)
            }
            return cell
        case .learningResource:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<LearnView>
            cell.customView.configure { [weak self] learnEvent in
                self?.handleLearnEventSelection(learnEvent)
            }
            return cell
        case .accomplishment:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<OverallProgressView>
            let data = AccomplishmentData(activityProgress: 75, contentProgress: 55, timeTrackingProgress: 30)
            cell.customView.configure(data: data)
            return cell
            
        default:
            let cell = UITableViewCell()
            cell.textLabel?.text = homeSection.title + " (Comming Soon)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handleCardViewSelection(indexPath: indexPath)
        
        guard let homeSection = self.homeSections[safe: indexPath.section] else {
            return
        }
        
        switch homeSection {
        case .activity:
            if let activity = topActivity {
                handleActivitySelection(activity)
            } else {
                //go to questionnaire
                openSurveyScreen()
            }

        case .learningResource:
            break
        default:
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let homeSection = self.homeSections[safe: section] else {
            return UITableViewHeaderFooterView()
        }
        
        var showButton: Bool
        switch homeSection {
        case .activity:
            showButton = true
        case .favoriteAcitivity:
            showButton = false
//        case .screenTime:
//            showButton = false
        case .learningResource:
            showButton = true
        case .accomplishment:
            showButton = true
        }
        
        let header = tableView.dequeueReusableView() as HeaderFooterHolderView<HomeHeaderView>
        header.layout.configure(title: homeSection.title, showButton: showButton) { [weak self] in
            switch homeSection {
            case .activity:
                (self?.tabBarController as? MainTabBarController)?.goToActivity()
            case .favoriteAcitivity:
                break
//            case .screenTime:
//                break
            case .learningResource:
                self?.handleLearnEventSelection(.all)
            case .accomplishment:
                self?.handleAccomplishmentSelection()
            }
            
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
}

extension HomeViewController: SurveyViewDelegate, UIGestureRecognizerDelegate {
    
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
    
    func shouldShowSurvey() -> Bool {
        switch ActivityManager.QuestionarySurveryEvent {
        case .notSubmitted, .remindLater:
            return true
        case .submitted, .declined:
            return false
        }
    }
    
    
    func surveyCompleted(with survey: Survey) {
        //let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled" + String(Int.random(in: 0...100)) + ".json")
        let jsonUrl = URL.documentsDirectory().appendingPathComponent("survey_filled.json")
        try? Survey.SaveToFile(survey: survey, url: jsonUrl)
        print( " Saved survey to: \n" , jsonUrl.path )
        
        ActivityManager.QuestionarySurveryEvent = .submitted
        ActivityManager.shared.submittedSurvey = survey
        ActivityManager.shared.sortAllActivities()
        setupData()
        showingSurveyVC?.dismiss(animated: false)
    }
    
    func surveyDeclined() {
        ActivityManager.QuestionarySurveryEvent = .declined
        showingSurveyVC?.dismiss(animated: false)
    }
    
    func surveyRemindMeLater() {
        ActivityManager.QuestionarySurveryEvent = .remindLater
        showingSurveyVC?.dismiss(animated: false)
    }
    
}
