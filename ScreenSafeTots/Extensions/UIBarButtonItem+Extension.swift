//
//  UIBarButtonItem+Extension.swift
//
//  Created by Md. Mehedi Hasan on 3/11/20.
//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String, size: CGFloat = 24.0) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.imageEdgeInsets = .zero
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size).isActive = true

        return menuBarItem
    }
}
