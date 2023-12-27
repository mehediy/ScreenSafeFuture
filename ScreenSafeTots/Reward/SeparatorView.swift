//
//  SeparatorView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit

class SeparatorView: BaseView {

    override func setupView() {
        super.setupView()
        
        self.backgroundColor = Theme.Color.background
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.heightAnchor == 8.0
    }
}
