//
//  RewardProgressView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 11/2/23.
//

import UIKit


struct RewardProgressData {
    let title: String
    let progress: String
    let firstImage: UIImage?
    let secondImage: UIImage?
    let thirdImage: UIImage?
}


class RewardProgressView: BaseView {
    
    let titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.textAlignment = .left
    }
    
    let progressLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.normal.withSize(13.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }
    
    let firstImageView: BaseImageView = BaseImageView.with {
        //$0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
    }
    
    let secondImageView: BaseImageView = BaseImageView.with {
        //$0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
    }
    
    let thirdImageView: BaseImageView = BaseImageView.with {
        //$0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
    }
    
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(progressLabel)
        addSubview(firstImageView)
        addSubview(secondImageView)
        addSubview(thirdImageView)
    }
    
    override func setupLayout() {
        super.setupLayout()

        titleLabel.topAnchor == self.topAnchor + 12.0.dynamic
        titleLabel.leftAnchor == self.leftAnchor + 16.0.dynamic
        titleLabel.heightAnchor == 24.0.dynamic
        
        progressLabel.topAnchor == self.topAnchor + 12.0.dynamic
        progressLabel.rightAnchor == self.rightAnchor - 16.0.dynamic
        progressLabel.heightAnchor == 24.0.dynamic
        
        
        firstImageView.heightAnchor == 60.dynamic
        firstImageView.widthAnchor == 60.dynamic
        secondImageView.heightAnchor == 60.dynamic
        secondImageView.widthAnchor == 60.dynamic
        thirdImageView.heightAnchor == 60.dynamic
        thirdImageView.widthAnchor == 60.dynamic
        
        
        firstImageView.topAnchor == titleLabel.bottomAnchor + 12.0
        firstImageView.centerXAnchor == self.centerXAnchor * 0.4
        
        secondImageView.topAnchor == titleLabel.bottomAnchor + 12.0
        secondImageView.centerXAnchor == self.centerXAnchor
        
        
        thirdImageView.topAnchor == titleLabel.bottomAnchor + 12.0
        thirdImageView.centerXAnchor == self.centerXAnchor * 1.6
        
        
        firstImageView.bottomAnchor == bottomAnchor - 16.0
    }
    
    
    func configure(data: RewardProgressData) {
        titleLabel.text = data.title
        progressLabel.text = data.progress
//        firstImageView.image = data.firstImage != nil ? UIImage(named: data.firstImage!) : nil
//        secondImageView.image = data.secondImage != nil ? UIImage(named: data.secondImage!) : nil
//        thirdImageView.image = data.thirdImage != nil ? UIImage(named: data.thirdImage!) : nil
        firstImageView.image = data.firstImage
        secondImageView.image = data.secondImage
        thirdImageView.image = data.thirdImage
    }
}
