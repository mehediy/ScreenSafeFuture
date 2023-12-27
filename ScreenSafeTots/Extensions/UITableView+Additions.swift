//
//  UITableView+Additions.swift
//
//  Created by Md. Mehedi Hasan on 6/9/21.
//


import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        
        let messageLabel = BaseLabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = Theme.Color.labelSecondary
        messageLabel.type = .multiline
        messageLabel.textAlignment = .center
        messageLabel.font = Theme.Font.normal.withSize(15.0.dynamic)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
    
    func addTopBackgroundView(viewColor: UIColor) {
        var frame = bounds  //UIScreen.main.bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = viewColor
        addSubview(view)
    }
}
