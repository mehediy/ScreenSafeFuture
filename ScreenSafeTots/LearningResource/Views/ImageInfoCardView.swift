//
//  ImageInfoCardView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/11/23.
//


import UIKit

struct ImageInfoCardData {
    let image: UIImage
    let title: String
    let subtitle: String
}


class ImageInfoCardView: RoundedShadowView {
    
    let titleImageView: BaseImageView = BaseImageView.with {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.primary
    }
    
    let titleLabel: BaseLabel = BaseLabel.with {
        //$0.text = ""
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.textAlignment = .left
    }
    
    let subtitleLabel: BaseLabel = BaseLabel.with {
        //$0.text = ""
        $0.font = Theme.Font.normal.withSize(13.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.textAlignment = .left
    }
    
    let accessoryImage: BaseImageView = BaseImageView.with {
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.primary
    }
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        
        contentsLayer.addSubview(titleImageView)
        contentsLayer.addSubview(titleLabel)
        contentsLayer.addSubview(subtitleLabel)
        contentsLayer.addSubview(accessoryImage)
        
        mainView.layer.cornerRadius = 8.0
        contentsLayer.layer.cornerRadius = 8.0
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleImageView.leftAnchor == contentsLayer.leftAnchor + 12.0.dynamic
        titleImageView.centerYAnchor == centerYAnchor
        titleImageView.heightAnchor == 40.0.dynamic
        titleImageView.widthAnchor == 40.0.dynamic

        titleLabel.topAnchor == contentsLayer.topAnchor + 12.0.dynamic
        titleLabel.leftAnchor == titleImageView.rightAnchor + 8.0.dynamic
        titleLabel.heightAnchor == 24.0.dynamic
        
        subtitleLabel.topAnchor == titleLabel.bottomAnchor + 4.0.dynamic
        subtitleLabel.leftAnchor == titleLabel.leftAnchor
        subtitleLabel.rightAnchor == titleLabel.rightAnchor
        subtitleLabel.bottomAnchor == contentsLayer.bottomAnchor - 12.0.dynamic
        subtitleLabel.heightAnchor == 18.0.dynamic
        
        accessoryImage.leftAnchor == titleLabel.rightAnchor + 8.dynamic
        accessoryImage.centerYAnchor == centerYAnchor
        accessoryImage.heightAnchor == 16.dynamic
        accessoryImage.widthAnchor == 16.dynamic
        accessoryImage.rightAnchor == rightAnchor - 12.0.dynamic
    }
    
    func configure(data: ImageInfoCardData) {
        self.titleImageView.image = data.image
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
    }
    
}
