//
//  UIViewController+Additions.swift
//
//  Created by Md. Mehedi Hasan on 6/7/20.
//

import UIKit

extension UIViewController {
    
    func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    func showAlert(message: String, withTitle title: String? = nil, buttonTitle: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        present(alertController, animated: true, completion: nil)
    }
    
    func showError(error: NSError) {
        showAlert(message: error.localizedDescription, withTitle: "Error")
    }
    
    
    static let TopMessageViewTagCode: Int = 8497103
    
    func showTopMessageInView(_ message: String) {
        
        if let messageLabel = view.viewWithTag(UIViewController.TopMessageViewTagCode) as? BaseLabel {
            messageLabel.text = message
            self.view.bringSubviewToFront(messageLabel)
        } else {
            let messageLabel = BaseLabel()
            messageLabel.text = message
            messageLabel.textColor = Theme.Color.labelSecondary
            messageLabel.type = .multiline
            messageLabel.textAlignment = .center
            messageLabel.font = Theme.Font.normal.withSize(15.0.dynamic)
            messageLabel.sizeToFit()
            messageLabel.tag = UIViewController.TopMessageViewTagCode
            
            self.view.addSubview(messageLabel)
            messageLabel.horizontalAnchors == self.view.horizontalAnchors + 16.0.dynamic
            messageLabel.centerYAnchor == self.view.centerYAnchor
            self.view.bringSubviewToFront(messageLabel)
        }
    }
    
    func hideTopMessageFromView() {
        if let messageLabel = view.viewWithTag(UIViewController.TopMessageViewTagCode) as? BaseLabel {
            messageLabel.removeFromSuperview()
        }
    }
    
    
    /**
     returns true only if the viewcontroller is presented.
     */
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            if let parent = parent, !(parent is UINavigationController || parent is UITabBarController) {
                return false
            }
            return true
        } else if let navController = navigationController, navController.presentingViewController?.presentedViewController == navController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
