//
//  InfoCardCell.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/10/23.
//

import UIKit

class InfoCardCell: UICollectionViewCell, ReusableView {
    
    //public var offerAd: OfferAd?
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.19
        view.layer.cornerRadius = 6.0
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Add all your subsequent subviews to your contentsLayer
    let contentsLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: BaseLabel = BaseLabel.with {
        //$0.text = ""
        $0.font = Theme.Font.medium.withSize(15.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.textAlignment = .center
        $0.minimumScaleFactor = 0.6
        $0.adjustsFontSizeToFitWidth = true
    }



    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        contentView.addSubview(mainView)
        mainView.addSubview(contentsLayer)
        contentsLayer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            
            contentsLayer.topAnchor.constraint(equalTo: mainView.topAnchor),
            contentsLayer.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            contentsLayer.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            contentsLayer.rightAnchor.constraint(equalTo: mainView.rightAnchor)
        ])
        
        titleLabel.edgeAnchors == contentsLayer.edgeAnchors + 4.dynamic
    }
    
    func configure(with labelText: String) {
        titleLabel.text = labelText
    }
}
