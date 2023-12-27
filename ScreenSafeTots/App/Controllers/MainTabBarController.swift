//
//  MainTabBarController.swift

//  Created by Md. Mehedi Hasan on 31/10/21.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        //bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.6)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBarController()
        addTabChangeObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTabBarController() {
        
        //disable automatic transparent tabBar in iOS 15
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            //tabBarAppearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        tabBar.tintColor = Theme.Color.primary
        
        let viewControllers = TabItem.allCases.map { $0.viewController }
        setViewControllers(viewControllers, animated: false)
    }
    
    func addTabChangeObserver() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "K_CHANGE_HOME_TAB"), object:nil , queue: nil) { (notification) in
            
            if let userInfo = notification.userInfo, let tabNumber = userInfo["tabNumber"] as? Int {
                print("......Hit in TabNumber, instanceID:\(self)")
                
                DispatchQueue.main.async {
                    
                    self.selectedIndex = tabNumber
                    
                    //check if that tab's view controller need to pop to root
                    if let popToRoot = userInfo["popToRoot"] as? String, popToRoot == "true" {
                        (self.viewControllers?[tabNumber] as? MainNavigationController)?.popToRootViewController(animated: false)
                    }
                    
                    //check if it has a segment to forward
                    if let segmentNumber = userInfo["segmentNumber"] as? Int,
                       let navigationController = self.viewControllers?[tabNumber] as? UINavigationController,
                       let pagingViewController = navigationController.viewControllers.first as? PagingViewController {
                        
                        pagingViewController.goto(page: segmentNumber)
                    }
                    
                }
                
            }
        }
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let tabItem = TabItem(rawValue: item.tag) else { return }
        
        makeBounceAnimation(item: item)
        
        print("Did select Tabitem: \(tabItem) !")
        
        switch tabItem {
        case .home:
            break
        case .activity:
            break
        case .resource:
            break
        case .screenTime:
            break
        case .Account:
            break
        }
    }
    
    
    func makeBounceAnimation(item: UITabBarItem) {
        // find index if the selected tab bar item,
        // then find the corresponding view and get its image,
        // the view position is offset by 1 because the first item is the background (at least in this case)
        guard let idx = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > idx + 1,
              let itemView = tabBar.subviews[safe: idx + 1],
              let imageView = getTabItemImageView(itemView: itemView) else {
                  return
              }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
    
    
    func getTabItemImageView(itemView: UIView) -> UIImageView? {
        //let imageView = tabBar.subviews[idx + 1].subviews.first as? UIImageView
        var allImageViews = [UIImageView]()
        func getSubview(view: UIView) {
            if let aView = view as? UIImageView {
                allImageViews.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: itemView)
        
        return allImageViews.first
    }

    
    func goToHome() {
        selectedIndex = TabItem.home.rawValue
    }
    
    func goToActivity() {
        selectedIndex = TabItem.activity.rawValue
    }
    
    func goToResources(type: LearningResourceType) {
        selectedIndex = TabItem.resource.rawValue
        ((viewControllers?[safe: TabItem.resource.rawValue] as? MainNavigationController)?.viewControllers.first as? ResourceViewController)?.filterType = type
    }
    
    func reloadHomeActivity() {
        ((viewControllers?[safe: TabItem.home.rawValue] as? MainNavigationController)?.viewControllers.first as? HomeViewController)?.setupData()
    }
    
}

extension MainTabBarController {
    enum TabItem: Int, CaseIterable {
        case home, activity, resource, screenTime, Account
        
        var viewController: UIViewController {
            var controller: UIViewController
            switch self {
            case .home:
                controller = HomeViewController()
                controller.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
            case .activity:
                controller = ActivityViewController()
                controller.tabBarItem = UITabBarItem(title: "Activity Advocator", image: UIImage(systemName: "figure.2.and.child.holdinghands"), selectedImage: UIImage(systemName: "figure.2.and.child.holdinghands"))
            case .resource:
                controller = ResourceViewController()
                controller.tabBarItem = UITabBarItem(title: "Resources", image: UIImage(named: "more_unfilled_icon"), selectedImage: UIImage(named: "more_filled_icon"))
            case .screenTime:
                controller = UIHostingController(rootView: ScreenTimeView().preferredColorScheme(.light))
                controller.tabBarItem = UITabBarItem(title: "Screen Time", image: UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName: "stopwatch.fill"))
            case .Account:
                controller = AccountViewController()
                controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
            }
            
            controller.tabBarItem.tag = self.rawValue
            return MainNavigationController(rootViewController: controller)
        }
    }
}

extension MainTabBarController {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Did select viewController: \(viewController.title ?? "") !")
    }
}

extension MainTabBarController {
    static func setupBackgroundView(for tabBar: UITabBar) {

        let safeView = UIView()
        //Intentional! currently, the tabbar tile images' colors does't match the primary color
        safeView.backgroundColor = UIColor(red: 54/255, green: 169/255, blue: 225/255, alpha: 1.0) //Theme.Color.primary
        safeView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor == 50
        
//        let centerImageView = UIImageView()
//        centerImageView.contentMode = .scaleAspectFill
//        centerImageView.clipsToBounds = true
//        centerImageView.translatesAutoresizingMaskIntoConstraints = false
//        centerImageView.image = UIImage(named: "tabbar_mid")
//        centerImageView.widthAnchor == 86
        
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.image = UIImage(named: "tabbar_left")
        leftImageView.widthAnchor == 12
        
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.image = UIImage(named: "tabbar_right")
        rightImageView.widthAnchor == 12
        
        let fillImageView = UIImageView()
        fillImageView.contentMode = .scaleAspectFill
        fillImageView.clipsToBounds = true
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.image = UIImage(named: "tabbar_background")
        
//        let leftFillImageView = UIImageView()
//        leftFillImageView.contentMode = .scaleAspectFill
//        leftFillImageView.clipsToBounds = true
//        leftFillImageView.translatesAutoresizingMaskIntoConstraints = false
//        leftFillImageView.image = UIImage(named: "tabbar_background")
        
//        let rightFillImageView = UIImageView()
//        rightFillImageView.contentMode = .scaleAspectFill
//        rightFillImageView.clipsToBounds = true
//        rightFillImageView.translatesAutoresizingMaskIntoConstraints = false
//        rightFillImageView.image = UIImage(named: "tabbar_background")
        
//        backgroundView.addSubview(centerImageView)
        backgroundView.addSubview(leftImageView)
//        backgroundView.addSubview(leftFillImageView)
        backgroundView.addSubview(fillImageView)
        backgroundView.addSubview(rightImageView)
//        backgroundView.addSubview(rightFillImageView)

        leftImageView.leftAnchor == backgroundView.leftAnchor
        leftImageView.verticalAnchors == backgroundView.verticalAnchors
        
        fillImageView.leftAnchor == leftImageView.rightAnchor
        fillImageView.verticalAnchors == backgroundView.verticalAnchors
        fillImageView.rightAnchor == rightImageView.leftAnchor
        
//        leftFillImageView.leftAnchor == leftImageView.rightAnchor
//        leftFillImageView.verticalAnchors == backgroundView.verticalAnchors
//        leftFillImageView.rightAnchor == centerImageView.leftAnchor
        
//        centerImageView.centerXAnchor == backgroundView.centerXAnchor
//        centerImageView.verticalAnchors == backgroundView.verticalAnchors
        
//        rightFillImageView.leftAnchor == centerImageView.rightAnchor
//        rightFillImageView.verticalAnchors == backgroundView.verticalAnchors
//        rightFillImageView.rightAnchor == rightImageView.leftAnchor
        
        rightImageView.rightAnchor == backgroundView.rightAnchor
        rightImageView.verticalAnchors == backgroundView.verticalAnchors
        
        tabBar.addSubview(backgroundView)
        tabBar.addSubview(safeView)
        
        safeView.topAnchor == tabBar.saferAreaLayoutGuide.bottomAnchor
        safeView.horizontalAnchors == tabBar.horizontalAnchors
        safeView.bottomAnchor == tabBar.bottomAnchor
        
        backgroundView.bottomAnchor == safeView.topAnchor
        backgroundView.horizontalAnchors == tabBar.horizontalAnchors
    }
}
