//
//  UIViewController+Extension.swift
//
//  Created by Md. Mehedi Hasan on 10/9/20.
//

import UIKit

extension UIViewController {
    
    func add(asChild viewController: UIViewController, view: UIView? = nil) {
        addChild(viewController)
        
        if let view = view {
            view.addSubview(viewController.view)
            viewController.view.horizontalAnchors == view.horizontalAnchors
            viewController.view.verticalAnchors == view.verticalAnchors
        } else {
            self.view.addSubview(viewController.view)
            viewController.view.horizontalAnchors == self.view.horizontalAnchors
            viewController.view.verticalAnchors == self.view.verticalAnchors
        }
        
        viewController.didMove(toParent: self)
    }
    
    
    func isChild(_ viewController: UIViewController) -> Bool {
        return  self.children.contains(viewController)
    }
    
    
    func remove(asChild viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
//    func setLeftAlignedNavigationItemTitle(text: String, imageName: String? = nil, closure: @escaping () -> Void) {
//
//        let titleLabel = with(BaseLabel()) {
//            $0.backgroundColor = .clear
//            $0.font = Theme.Font.bold.withSize(18)
//            $0.textAlignment = .left
//            $0.textColor = .white
//            $0.text = text
//            //$0.sizeToFit()
//            //$0.heightAnchor >= 44.0
//            $0.isUserInteractionEnabled = false
//        }
//
//        let titleButtonItem = UIBarButtonItem(customView: titleLabel)
//        let imageName = imageName ?? "icon_chevron_left_mono"
//        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), style: .plain) { _ in
//            closure()
//        }
//        navigationItem.leftBarButtonItems = [backBarButtonItem, titleButtonItem]
//    }
    
}


