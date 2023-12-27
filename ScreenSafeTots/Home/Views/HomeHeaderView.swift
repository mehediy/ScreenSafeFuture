//
//  HomeHeaderView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/3/23.
//

import UIKit

class HomeHeaderView: BaseView, ViewLayout {
    
    
    let separatorView: BaseView = BaseView.with {
        $0.heightAnchor == 3.0
        $0.backgroundColor = Theme.Color.background
    }
    
    let titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.bold.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.header
        $0.textAlignment = .left
    }
    
    let actionButton: BaseButton = BaseButton.with {
        $0.setTitle("See All", for: .normal)
        $0.setTitleColor(Theme.Color.telenorLink, for: .normal)
        $0.titleLabel?.font = Theme.Font.normal.withSize(15.0.dynamic)
    }

    
    func layout(on view: UIView) {
        view.addSubview(self)
        self.edgeAnchors == view.edgeAnchors
    }
    
    override func setupView() {
        super.setupView()
        
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func setupLayout() {
        super.setupLayout()
        

        separatorView.topAnchor == topAnchor
        separatorView.horizontalAnchors == horizontalAnchors
        
        
        titleLabel.topAnchor == separatorView.bottomAnchor + 12.0.dynamic
        titleLabel.leftAnchor == leftAnchor + 16.0.dynamic
        titleLabel.heightAnchor == 24.0.dynamic
        titleLabel.bottomAnchor == bottomAnchor - 10.0.dynamic
        
        actionButton.centerYAnchor == titleLabel.centerYAnchor
        actionButton.rightAnchor == rightAnchor - 16.0.dynamic
        actionButton.heightAnchor == 24.0.dynamic
    }
    
    var callback: (() -> Void)?
    func configure(title: String, showButton: Bool, callback: (() -> Void)?) {
        titleLabel.text = title
        actionButton.isHidden = !showButton
        self.callback = callback
    }
    
    
    @objc func sortButtonTapped(_ sender: Any) {
        callback?()
    }

    
}

