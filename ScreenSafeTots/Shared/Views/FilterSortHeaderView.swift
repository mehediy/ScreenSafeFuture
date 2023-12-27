//
//  SortFilterHeaderView.swift
//
//  Created by Md. Mehedi Hasan on 3/11/20.

import UIKit

class SortFilterHeaderView: UITableViewHeaderFooterView {

    private let titleLabel: BaseLabel = BaseLabel.with {
        //$0.text = "Sort by".localiz()
        $0.type = .multiline
        $0.font = Theme.Font.medium.withSize(13)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }

    private let sortFilterButton: BaseButton = BaseButton.with {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        //$0.setTitle("Default".localiz(), for: .normal)
        $0.tintColor = Theme.Color.labelSecondary
        $0.titleLabel?.font = Theme.Font.normal.withSize(13)
        $0.setTitleColor(Theme.Color.codGray, for: .normal)
        $0.backgroundColor = Theme.Color.background
        $0.layer.cornerRadius = 3.0
        $0.clipsToBounds = true
        //$0.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        $0.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        $0.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        $0.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        let buttonWidth: CGFloat = 100
//        let imageWidth: CGFloat = 24
//        let spacing: CGFloat = 8.0 / 2
//        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-imageWidth + spacing, bottom: 0, right: -(buttonWidth-imageWidth) - spacing)
//        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - spacing, bottom: 0, right: imageWidth + spacing)
//        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    }
    
    var widthConstraint: NSLayoutConstraint!

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = .white
        
        sortFilterButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(sortFilterButton)
        
        titleLabel.centerYAnchor == contentView.centerYAnchor
        
        sortFilterButton.leftAnchor == titleLabel.rightAnchor + 8
        widthConstraint = sortFilterButton.widthAnchor >= 100
        sortFilterButton.heightAnchor == 28
        sortFilterButton.centerYAnchor == contentView.centerYAnchor
        sortFilterButton.rightAnchor == contentView.rightAnchor - 8
//        sortFilterButton.invalidateIntrinsicContentSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var callback: (() -> Void)?
    func configure(title: String, selectedType: String, callback: (() -> Void)?) {
        titleLabel.text = title
        setupSelectedType(selectedType)
        self.callback = callback
    }
    
    func setupSelectedType(_ selectedType: String) {
        let title = selectedType + "  "
        sortFilterButton.setTitle(title, for: .normal)
        
        if widthConstraint.constant < sortFilterButton.intrinsicContentSize.width {
            widthConstraint.isActive = false
            widthConstraint = sortFilterButton.widthAnchor >= sortFilterButton.intrinsicContentSize.width + 12
        } else {
            widthConstraint.isActive = false
            widthConstraint = sortFilterButton.widthAnchor >= 100
        }

    }
    
    @objc func sortButtonTapped(_ sender: Any) {
        callback?()
    }

}
