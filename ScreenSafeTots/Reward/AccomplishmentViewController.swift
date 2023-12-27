//
//  AccomplishmentViewController.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit
import SwiftUI

enum AccomplishmentSection: Int, CaseIterable, Codable {

    case overall
    
    case separator
    
    case activity
    
    case content
    
    case timeTracking
}


class AccomplishmentViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }

    //let tableView: BaseTableView = BaseTableView.with {
    let tableView = with(UITableView(frame: .zero, style: .grouped)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white //Theme.Color.background
        $0.separatorStyle = .none
        $0.register(TableViewCell<OverallProgressView>.self)
        $0.register(TableViewCell<SeparatorView>.self)
        $0.register(TableViewCell<RewardProgressView>.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 150
        //$0.contentInset.top = 4
        //$0.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        //$0.tableFooterView = UIView(frame: frame)
    }
    
    var isfirstTimeLoad: Bool = true
    
    ///use this array as datasource for tableview
    private var accomplishmentSections: [AccomplishmentSection] = AccomplishmentSection.allCases
    let accomplishmentData = AccomplishmentData(activityProgress: 75, contentProgress: 55, timeTrackingProgress: 30)
    
    //MARK: - ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Accomplishments"
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
        
        view.backgroundColor = .white
        
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
extension AccomplishmentViewController: UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return accomplishmentSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = self.accomplishmentSections[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch section {
        case .overall:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<OverallProgressView>
            cell.customView.configure(data: accomplishmentData)
            return cell
            
        case .separator:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<SeparatorView>
            return cell
        case .activity:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<RewardProgressView>
            let data = RewardProgressData(title: "Activity Completion Progress",
                                          progress: accomplishmentData.activityProgressLabel,
                                          firstImage: accomplishmentData.activityImageFirst,
                                          secondImage: accomplishmentData.activityImageSecond,
                                          thirdImage: accomplishmentData.activityImageThird)
            cell.customView.configure(data: data)
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<RewardProgressView>
            let data = RewardProgressData(title: "Content Reading Progress",
                                          progress: accomplishmentData.contentProgressLabel,
                                          firstImage: accomplishmentData.contentImageFirst,
                                          secondImage: accomplishmentData.contentImageSecond,
                                          thirdImage: accomplishmentData.contentImageThird)
            cell.customView.configure(data: data)
            return cell
        case .timeTracking:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<RewardProgressView>
            let data = RewardProgressData(title: "Screen Monitoring Progress",
                                          progress: accomplishmentData.timeTrackingProgressLabel,
                                          firstImage: accomplishmentData.timeTrackingImageFirst,
                                          secondImage: accomplishmentData.timeTrackingImageSecond,
                                          thirdImage: accomplishmentData.timeTrackingImageThird)
            cell.customView.configure(data: data)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //handleCardViewSelection(indexPath: indexPath)
        
    }

}
