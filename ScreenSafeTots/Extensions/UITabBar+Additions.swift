//
//  UITabBar+Additions.swift
//
//  Created by Md. Mehedi Hasan on 19/1/22.
//

import UIKit

fileprivate let tabBarItemTag: Int = 10090

extension UITabBar {
    
    func addItemBadge(atIndex index: Int) {
        guard let itemCount = self.items?.count, itemCount > 0 else {
            return
        }
        guard index < itemCount else {
            return
        }
        removeItemBadge(atIndex: index)
        
        let badgeView = UIView()
        badgeView.tag = tabBarItemTag + Int(index)
        badgeView.layer.cornerRadius = 5
        badgeView.backgroundColor = UIColor.red
        
        let tabFrame = self.frame
        let percentX = (CGFloat(index) + 0.56) / CGFloat(itemCount)
        let x = (percentX * tabFrame.size.width).rounded(.up)
        let y = (CGFloat(0.1) * tabFrame.size.height).rounded(.up)
        badgeView.frame = CGRect(x: x, y: y, width: 10, height: 10)
        addSubview(badgeView)
    }
    
    //return true if removed success.
    @discardableResult
    func removeItemBadge(atIndex index: Int) -> Bool {
        for subView in self.subviews {
            if subView.tag == (tabBarItemTag + index) {
                subView.removeFromSuperview()
                return true
            }
        }
        return false
    }
}
