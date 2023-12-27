//
//  AccountButtonView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 9/8/23.
//

import UIKit


class AccountButtonView: UIView {
    
    let containerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    
    let walletLabel: BaseLabel = BaseLabel.with {
        $0.text = "Don't have a account?"
        $0.textColor = Theme.Color.manatee
        $0.font = Theme.Font.normal.withSize(15.0.dynamic)
    }
    
    let accountButton: BaseButton = BaseButton.with {
        $0.setTitle("Create Account", for: .normal)
        $0.setTitleColor(Theme.Color.telenorLink, for: .normal)
        $0.titleLabel?.font = Theme.Font.medium.withSize(15.0.dynamic)
    }
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(walletLabel)
        containerView.addSubview(accountButton)
    }
    
    func setupLayout() {
        
        containerView.verticalAnchors == self.verticalAnchors + 8.0.dynamic
        containerView.horizontalAnchors >= self.horizontalAnchors
        containerView.centerXAnchor == self.centerXAnchor
        
        walletLabel.topAnchor == containerView.topAnchor
        walletLabel.leftAnchor == containerView.leftAnchor
        walletLabel.bottomAnchor == containerView.bottomAnchor
        
        accountButton.leftAnchor == walletLabel.rightAnchor + 6.0.dynamic
        accountButton.rightAnchor == containerView.rightAnchor
        accountButton.topAnchor == containerView.topAnchor
        accountButton.bottomAnchor == containerView.bottomAnchor
        accountButton.heightAnchor == 28.0.dynamic
        //walletButton.widthAnchor == 68.0.dynamic
    }
}
