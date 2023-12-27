//
//  BadgedButtonItem.swift
//
//  Created by Md. Mehedi Hasan on 22/9/20.


import UIKit

enum BadgeSize {
    case extraSmall // 10
    case small      // 14
    case medium     // 16
    case large      // 18
}

class BadgedButton: UIButton {

    var badgeTintColor: UIColor? {
        didSet {
            badgeLabel.backgroundColor = badgeTintColor
        }
    }
    
    var badgeTextColor: UIColor? {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    var badgeSize: BadgeSize = .medium {
        didSet {
            switch badgeSize {
            case .extraSmall:
                self.badgeRadius = 5.0
            case .small:
                self.badgeRadius = 7.0
            case .medium:
                self.badgeRadius = 8.0
            case .large:
                self.badgeRadius = 9.0
            }
        }
    }
    
    private var badgeRadius: CGFloat = 8.0 {
        didSet {
            self.badgeLabel.layer.cornerRadius = badgeRadius
        }
    }
    
    var badgeNumber: Int? = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let badgeLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.light.withSize(9)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.isHidden = true
        $0.layer.cornerRadius = 5
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
        $0.layer.zPosition = 1
    }
    
    private var actionHandler: (() -> Void)?
    
    convenience init(image: UIImage?, actionHandler: (() -> Void)?) {
        self.init(type: .custom)
        self.setImage(image, for: .normal)
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        self.actionHandler = actionHandler
        
        addBadgeLabel()
    }
    
    @objc func buttonPressed(_ sender: Any) {
        actionHandler?()
    }
    
    private func addBadgeLabel() {
        addSubview(badgeLabel)
        badgeLabel.widthAnchor == 10  //14
        badgeLabel.heightAnchor == 10 //14
        //badgeLabel.widthAnchor >= 16
        badgeLabel.centerYAnchor == topAnchor
        badgeLabel.centerXAnchor == rightAnchor
    }
    
    private func updateBadge() {
        if let badgeNumber = badgeNumber {
            if badgeNumber > 0 {
                badgeLabel.text = "\(badgeNumber)"
            } else {
                badgeLabel.text = ""
            }
            
            badgeLabel.isHidden = false
            
        } else {
            badgeLabel.isHidden = true
        }
    }
}

class BadgeView: BaseView {

    var badgeTintColor: UIColor? {
        didSet {
            badgeLabel.backgroundColor = badgeTintColor
        }
    }
    
    var badgeTextColor: UIColor? {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    var badgeSize: BadgeSize = .medium {
        didSet {
            var badgeRadius: CGFloat = 8.0
            var fontSize: CGFloat = 8.0
            
            switch badgeSize {
            case .extraSmall:
                badgeRadius = 5.0
                fontSize = 8.0
            case .small:
                badgeRadius = 7.0
                fontSize = 9.0
            case .medium:
                badgeRadius = 8.0
                fontSize = 12.0
            case .large:
                badgeRadius = 9.0
                fontSize = 15.0
            }
            
            badgeLabel.layer.cornerRadius = badgeRadius
            badgeLabel.font = Theme.Font.light.withSize(fontSize)
        }
    }

    
    var badgeCount: Int? = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let badgeLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.light.withSize(9)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.isHidden = true
        $0.layer.cornerRadius = 5
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
        $0.layer.zPosition = 1
    }
    
    private var actionHandler: (() -> Void)?
    
    override func setupView() {
        backgroundColor = .clear
        addSubview(badgeLabel)
    }
    
    override func setupLayout() {
        badgeLabel.widthAnchor == 14.0
        badgeLabel.heightAnchor == 14.0
        badgeLabel.centerYAnchor == centerYAnchor
        badgeLabel.centerXAnchor == centerXAnchor
        //        badgeLabel.centerYAnchor == topAnchor
        //        badgeLabel.centerXAnchor == rightAnchor
    }
    
    private func updateBadge() {
        if let badgeNumber = badgeCount {
            if badgeNumber > 0 {
                badgeLabel.text = NSNumber(value: badgeNumber).stringValue //"\(badgeNumber)"
            } else {
                badgeLabel.text = ""
            }
            
            badgeLabel.isHidden = false
            
        } else {
            badgeLabel.isHidden = true
        }
    }
}
