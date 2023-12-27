//
//  AppHomeViewController.swift

//  Created by Md. Mehedi Hasan on 26/7/22.
//

import UIKit

class AppHomeViewController: RootViewController {
    
    let tabBarVC: MainTabBarController = MainTabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        self.view.backgroundColor = .white
        
        addChild(tabBarVC)
        self.containerView.addSubview(tabBarVC.view)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        tabBarVC.view.edgeAnchors == self.containerView.edgeAnchors
    }
    
    
    //MARK: - Helpers
    func goToPending(filteringDate: Date? = nil) {
        //tabBarVC.goToPending(filteringDate: filteringDate)
    }


}
