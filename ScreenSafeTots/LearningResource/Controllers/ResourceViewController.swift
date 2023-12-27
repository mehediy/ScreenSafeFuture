//
//  ResourceViewController.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/11/23.
//

import UIKit

class ResourceViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    let topContainerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    var topContainerViewHeightLC: NSLayoutConstraint!
    
    //let tableView: BaseTableView = BaseTableView.with {
    let tableView = with(UITableView(frame: .zero, style: .grouped)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white //Theme.Color.background
        $0.separatorStyle = .none
        $0.register(TableViewCell<ImageInfoCardView>.self)
        $0.register(SortFilterHeaderView.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 150
        //$0.contentInset.top = 4
        //$0.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        //$0.tableFooterView = UIView(frame: frame)
    }
    
    var isfirstTimeLoad: Bool = true
    
    ///use this array as datasource for tableview

    let learningResources: [LearningResource] = {
        if let response: LearningResourceResponse = AppUtility.loadJson(filename: "learning_resource") {
            return response.learningResources.shuffled()
        } else {
            return []
        }
    }()
    
    private var filteredLearningResources: [LearningResource] = []
    
    var filterType: LearningResourceType = .all {
        didSet {
            updateFilteredResource()
            tableView.reloadData()
        }
    }
    
    private func updateFilteredResource() {
        switch filterType {
        case .all:
            filteredLearningResources = learningResources
        case .website:
            filteredLearningResources = learningResources.filter { $0.type == .website }
        case .pdf:
            filteredLearningResources = learningResources.filter { $0.type == .pdf }
        case .video:
            filteredLearningResources = learningResources.filter { $0.type == .video }
        }
    }
    
    
    
    
    //var storedWidgets: [HomeWidgetModel] = UserDefaultsStore<HomeWidgetModel>.homeWidget.arrayValue ?? []
    
    //MARK: - ViewController's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateFilteredResource()
        
        //AnalyticsManager.shared.logEvent("In_app_messaging", parameters:nil)
        
        //update firebase token if any update
        //FirebaseService.updateFirebaseToken()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tableView.reloadData()
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
    
    private func setupNavBar() {
        
        //self.title = "ScreenSafeTots"
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        rightBarItem.setTitleTextAttributes([.font: Theme.Font.medium.withSize(18)], for: .normal)
        rightBarItem.setTitlePositionAdjustment(UIOffset(horizontal: 0.0, vertical: 5.0), for: .default)
        navigationItem.rightBarButtonItem = rightBarItem
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
    
    func handleSelection(resource: LearningResource) {
        
        if let webURL = URL(string: resource.link) {
            let webVC = WebViewController(url: webURL)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    private func showFilterPicker() {
        let filterItems = LearningResourceType.allCases.map { $0.title }
        let mcPicker = McPicker(data: [filterItems])
        
        mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            guard let self = self else { return }
            if let selectedItem = selections[0] {
                print("selected Item: \(selectedItem)")
                if let index = filterItems.firstIndex(of: selectedItem), let filterType = LearningResourceType(intValue: index) {
                    self.filterType = filterType
                    let view = self.tableView.headerView(forSection: 0)
                    if let headerView = self.tableView.headerView(forSection: 0) as? SortFilterHeaderView {
                        headerView.setupSelectedType(filterType.title)
                    }
                } else {
                    //self.showWarningMessage("Invalid selection")
                }
            }
        }, cancelHandler: {
            print("Canceled Styled Picker")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Section \(componentThatChanged) changed value to \(newSelection)")
        })
    }
}


//MARK: Delegate, DataSource
extension ResourceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLearningResources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let learningResource = self.filteredLearningResources[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell<ImageInfoCardView>
        
        let data = ImageInfoCardData(image: UIImage(systemName: learningResource.type.imageName)!,
                                     title: learningResource.title,
                                     subtitle: learningResource.objective)
        cell.customView.configure(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let learningResource = self.filteredLearningResources[safe: indexPath.row] else { return }
        
        handleSelection(resource: learningResource)
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableView() as SortFilterHeaderView
        header.configure(title: "Learning Resource Type", selectedType: filterType.title) { [weak self] in
            self?.showFilterPicker()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

