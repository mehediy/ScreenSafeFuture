//
//  PagingViewController.swift
//
//  Created by Md. Mehedi Hasan on 10/9/20.

import UIKit

enum HorizontalDirection: CaseIterable {
    case left
    case right
}

class PagingViewDataSource {
    let menu: String
    let content: UIViewController
    let menuIcon: UIImage?
    var badgeCount: Int?
    
    init(menu: String, content: UIViewController, menuIcon: UIImage? = nil, badgeCount: Int? = nil) {
        self.menu = menu
        self.content = content
        self.menuIcon = menuIcon
        self.badgeCount = badgeCount
    }
}

class PagingViewController: UIViewController {
    
    lazy var menuViewController = with(PagingMenuViewController()){
        $0.view.backgroundColor = Theme.Color.primary
        $0.dataSource = self
        $0.delegate = self
    }
    
    lazy var contentViewController = with(PagingContentViewController()){
        $0.dataSource = self
        $0.delegate = self
    }
    
    let focusView = with(PagingUnderlineFocusView()) {
        $0.underlineHeight = 2.0
        $0.underlineColor = UIColor.white
    }
    
    lazy var aboveView: BaseView = BaseView.with {
        $0.backgroundColor = Theme.Color.background
    }
    
    let menuView: BaseView = BaseView.with {
        $0.backgroundColor = Theme.Color.primary
    }
       
    let containerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    
    lazy var leftButton = with(UIButton()){
        $0.setImage(UIImage(named: "tabLeft"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.imageView?.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.addTarget(self, action: #selector(leftButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var rightButton = with(UIButton()){
        $0.setImage(UIImage(named: "tabRight"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.imageView?.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
    }
    
    var showMenuIcon: Bool = false
    var showMenuBadge: Bool = false
    
    /// this property need to be set before calling `super.viewDidLoad()`
    var topSpace: CGFloat = 0
    var menuBarHeight: CGFloat = 60
    
    var focusFont = Theme.Font.bold.withSize(16)
    var normalFont = Theme.Font.normal.withSize(16)
    var focusColor = UIColor.white
    var normalColor = Theme.Color.boulder
    var badgeColor = Theme.Color.redRibbon
    var menuBackgroundColor = Theme.Color.boulder
    var menuFixedWidth: CGFloat?
    var focusPadding: CGFloat = 0
    
    var focusViewDidEndTransition: (() -> Void)?
    var didChangeMenuIndex: ((Int) -> Void)?
    var didFinishPagingIndex: ((Int) -> Void)?
    
    var viewDidLoaded: Bool = false
    var gotoPageIndex: Int?
    
    
    var dataSources: [PagingViewDataSource] = []
    
    var hasViewAboveMenuView = false
    private var showHorizontalScrollButtons = false
    
    lazy var firstLoad: (() -> Void)? = { [weak self, menuViewController, contentViewController, focusView] in
        menuViewController.registerFocusView(view: focusView, padding: self?.focusPadding ?? 0)
        menuViewController.reloadData()
        contentViewController.reloadData { [weak self] in
            self?.adjustfocusViewWidth(index: 0, percent: 0)
        }
        self?.firstLoad = nil
        self?.processDeferredGotoPageIndex()
    }
    
    func reload(){
        
        self.firstLoad = { [weak self, menuViewController, contentViewController,focusView] in
            menuViewController.registerFocusView(view: focusView,padding: self?.focusPadding ?? 0)
            menuViewController.reloadData()
            contentViewController.reloadData { [weak self] in
                self?.adjustfocusViewWidth(index: 0, percent: 0)
            }
            self?.firstLoad = nil
            self?.processDeferredGotoPageIndex()
        }
        self.view.setNeedsLayout()
        self.view.layoutSubviews()
    }
    
    
    ///goto the page which is deferred earlier
    private func processDeferredGotoPageIndex() {
        if let gotoPageIndex = self.gotoPageIndex {
            self.goto(page: gotoPageIndex)
        }
    }
    
    
    func goto(page: Int) {
        
        //defer the goto request if page is not loaded properly yet or reloading is ongoing.
        if !viewDidLoaded || firstLoad != nil {
            gotoPageIndex = page
            return
        }
        
        var shouldAddDelay: Bool = false
        if gotoPageIndex != nil {
            shouldAddDelay = true
            gotoPageIndex = nil
        }
        
        let delay: Double = shouldAddDelay ? 0.15 : 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.gotoInternal(page: page)
        }
    }
    
    
    private func gotoInternal(page: Int) {
        
        contentViewController.scroll(to: page, animated: true)
        let deadlineTime = DispatchTime.now() + .microseconds(10)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {  [weak self] in
            self?.menuViewController.menuView.scroll(index: page, completeHandler: { [weak self] (finish) in
               guard let _self = self, finish else { return }
              
               _self.menuViewController.delegate?.menuViewController(viewController: _self.menuViewController, focusViewDidEndTransition: _self.menuViewController.menuView.focusView)
           })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(menuView)
        self.view.addSubview(containerView)
        
        if hasViewAboveMenuView {
            view.addSubview(aboveView)
            aboveView.horizontalAnchors == view.horizontalAnchors
            menuView.topAnchor == aboveView.bottomAnchor
        }
        
        if hasViewAboveMenuView {
            aboveView.topAnchor == self.view.saferAreaLayoutGuide.topAnchor + topSpace
            menuView.topAnchor == aboveView.bottomAnchor
        } else {
            menuView.topAnchor == self.view.saferAreaLayoutGuide.topAnchor + topSpace
        }
       
        menuView.horizontalAnchors == self.view.horizontalAnchors
        menuView.heightAnchor == menuBarHeight
    
        containerView.topAnchor == menuView.bottomAnchor
        containerView.horizontalAnchors == self.view.horizontalAnchors
        //containerView.bottomAnchor == self.view.saferAreaLayoutGuide.bottomAnchor
        containerView.bottomAnchor == self.view.bottomAnchor
        
        self.add(asChild: menuViewController, view: menuView)
        self.add(asChild: contentViewController, view: containerView)
        
        menuViewController.register(type: PagingTitleMenuViewCell.self, forCellWithReuseIdentifier: "identifier")
        contentViewController.scrollView.bounces = true

        menuViewController.registerFocusView(view: focusView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureHorizontalScrollButtons()
        
        viewDidLoaded = true
        processDeferredGotoPageIndex()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstLoad?()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PagingViewController {
    
    func setupHorizontalScrollButtons() {
        showHorizontalScrollButtons = true
        
        menuView.addSubview(leftButton)
        menuView.addSubview(rightButton)
        
        leftButton.leftAnchor == menuView.leftAnchor
        leftButton.centerYAnchor == menuView.centerYAnchor
        leftButton.heightAnchor == 24.0 //* factX
        leftButton.widthAnchor == 24.0 //* factY
        
        rightButton.rightAnchor == menuView.rightAnchor
        rightButton.centerYAnchor == menuView.centerYAnchor
        rightButton.heightAnchor == 24.0 //* factX
        rightButton.widthAnchor == 24.0 //* factY
    }

    func configureHorizontalScrollButtons() {
        
        guard showHorizontalScrollButtons else { return }
        
        leftButton.isHidden = true
        rightButton.isHidden = true
        let menuView = menuViewController.menuView
        if (menuView.contentSize.width > menuView.frame.size.width) {
            if menuView.contentOffset.x > 0 || menuView.contentOffset.x > menuView.contentSize.width {
                leftButton.isHidden = false
            }
            
            if menuView.contentOffset.x + menuView.frame.size.width < menuView.contentSize.width - 1 {
                rightButton.isHidden = false
            }
        }
    }

    private func scrollPagingMenuView(direction: HorizontalDirection, animated: Bool){
        let tabScrollArea: CGFloat = 250
        let menuView = menuViewController.menuView
        let limitX:CGFloat = menuView.contentSize.width - menuView.frame.size.width
        var contentOffSetX: CGFloat =  0
        switch direction {
        case .left:
            contentOffSetX = menuView.contentOffset.x - tabScrollArea
            if contentOffSetX < 0 {
                contentOffSetX = 0
            }
        case .right:
            contentOffSetX = menuView.contentOffset.x + tabScrollArea
            if contentOffSetX > limitX {
                contentOffSetX = limitX
            }
        }
        menuView.setContentOffset(CGPoint(x: contentOffSetX, y: 0), animated: animated)
    }

    //MARK:- Actions
    @objc private func leftButtonTapped(_ sender: UIButton) {
        scrollPagingMenuView(direction: .left, animated: true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25) { [weak self] in
            self?.configureHorizontalScrollButtons()
        }
    }

    @objc private func rightButtonTapped(_ sender: UIButton) {
        scrollPagingMenuView(direction: .right, animated: true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25) { [weak self] in
            self?.configureHorizontalScrollButtons()
        }
    }
}

extension PagingViewController: PagingMenuViewControllerDataSource {
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index)  as! PagingTitleMenuViewCell
        
        let dataSource = dataSources[index]
        
        cell.titleLabel.text = dataSource.menu
        if showMenuIcon {
            cell.setImage(dataSource.menuIcon)
        }
        if showMenuBadge {
            cell.setBadgeCount(dataSource.badgeCount)
            cell.badgeLabel.backgroundColor = badgeColor
        }
        
        //cell.focusFont = self.focusFont
        //cell.normalFont = self.normalFont
        cell.focusColor = self.focusColor
        cell.normalColor = self.normalColor
        cell.backgroundColor = self.menuBackgroundColor
        return cell
    }

    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        
        if let width = self.menuFixedWidth {
           return width
        }
        
        PagingTitleMenuViewCell.sizingCell.titleLabel.text = dataSources[index].menu
        var referenceSize = UIView.layoutFittingCompressedSize
        referenceSize.height = viewController.view.bounds.height
        let size = PagingTitleMenuViewCell.sizingCell.systemLayoutSizeFitting(referenceSize)
        return size.width + 20
        
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSources.count
    }
}

extension PagingViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSources.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSources[index].content
    }
}

extension PagingViewController: PagingMenuViewControllerDelegate {
    
    func menuViewController(viewController: PagingMenuViewController, focusViewDidEndTransition focusView: PagingMenuFocusView) {
        focusViewDidEndTransition?()
        configureHorizontalScrollButtons()
    }
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        self.didChangeMenuIndex?(page)
        contentViewController.scroll(to: page, animated: true)
    }
}

extension PagingViewController: PagingContentViewControllerDelegate {
    
    func contentViewController(viewController: PagingContentViewController, didEndManualScrollOn index: Int){
         self.didChangeMenuIndex?(index)
    }

    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
        adjustfocusViewWidth(index: index, percent: percent)
    }
    
    func adjustfocusViewWidth(index: Int, percent: CGFloat) {
        guard let leftCell = menuViewController.cellForItem(at: index) as? PagingTitleMenuViewCell,
            let rightCell = menuViewController.cellForItem(at: index + 1) as? PagingTitleMenuViewCell else {
            return
        }
        focusView.underlineWidth = rightCell.calcIntermediateLabelSize(with: leftCell, percent: percent)
    }
    
    func contentViewController(viewController: PagingContentViewController, didFinishPagingAt index: Int, animated: Bool) {
        self.didFinishPagingIndex?(index)
    }
    
}
