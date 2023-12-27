//
//  OverallProgressView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit


class OverallProgressView: BaseView {
    
    let titleLabel: BaseLabel = BaseLabel.with {
        $0.text = "Overall Progress"
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.textAlignment = .left
    }
    
    let progressLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.normal.withSize(13.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }
    
    let badgeImageView: BaseImageView = BaseImageView.with {
        //$0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.primary
    }
    
    let badgeLabel: BaseLabel = BaseLabel.with {
        $0.text = "Badgets earned"
        $0.font = Theme.Font.normal.withSize(13.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }
    
    let awardImageView: BaseImageView = BaseImageView.with {
        //$0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.primary
    }
    
    let awardLabel: BaseLabel = BaseLabel.with {
        $0.text = "Awards earned"
        $0.font = Theme.Font.normal.withSize(13.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }
    
    override func setupView() {
        super.setupView()
        
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(progressLabel)
        addSubview(badgeLabel)
        addSubview(awardLabel)
        addSubview(badgeImageView)
        addSubview(awardImageView)
    }
    
    override func setupLayout() {
        super.setupLayout()

        titleLabel.topAnchor == self.topAnchor + 12.0.dynamic
        titleLabel.leftAnchor == self.leftAnchor + 16.0.dynamic
        titleLabel.heightAnchor == 24.0.dynamic
        
        progressLabel.topAnchor == self.topAnchor + 12.0.dynamic
        progressLabel.rightAnchor == self.rightAnchor - 16.0.dynamic
        progressLabel.heightAnchor == 24.0.dynamic
        
        
        badgeImageView.heightAnchor == 80.dynamic
        badgeImageView.widthAnchor == 80.dynamic
        awardImageView.heightAnchor == 80.dynamic
        awardImageView.widthAnchor == 80.dynamic
        
        badgeImageView.topAnchor == titleLabel.bottomAnchor + 12.0
        badgeImageView.centerXAnchor == self.centerXAnchor * 0.55
        badgeLabel.topAnchor == badgeImageView.bottomAnchor + 6.0
        badgeLabel.centerXAnchor == badgeImageView.centerXAnchor
        
        
        awardImageView.topAnchor == badgeImageView.topAnchor
        awardImageView.centerXAnchor == self.centerXAnchor * 1.45
        awardLabel.topAnchor == awardImageView.bottomAnchor + 6.0
        awardLabel.centerXAnchor == awardImageView.centerXAnchor
        
        
        badgeLabel.bottomAnchor == bottomAnchor - 20.0
    }
    
    func configure(data: AccomplishmentData) {
        progressLabel.text = data.overallProgressLabel
        badgeImageView.image = data.badgeImage
        awardImageView.image = data.awardImage
    }
    
}
