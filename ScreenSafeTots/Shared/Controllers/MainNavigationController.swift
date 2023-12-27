//
//  MainNavigationController.swift
//
//  Created by Mehedi Hasan on 2/6/19.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = .clear
        
        navigationBar.barStyle = .default
        
        // color for button images, indicators and etc.
        navigationBar.tintColor = .white

        let attributes: [NSAttributedString.Key : Any] = [.font: Theme.Font.medium.withSize(18),
                                                          .foregroundColor: UIColor.white]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = attributes
            appearance.backgroundColor = Theme.Color.primary
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            // color for standard title label
            navigationBar.titleTextAttributes = attributes
            // color for background of navigation bar
            navigationBar.barTintColor = Theme.Color.primary
            navigationBar.isTranslucent = false
            // remove bottom line/shadow
            navigationBar.shadowImage = UIImage()
        }

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        let titleText = "  \(viewController.title != nil ? viewController.title! : "")"
//        viewController.title = nil
        let titleText = " "
        self.visibleViewController?.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: titleText, style: .plain, target: nil, action: nil)
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
