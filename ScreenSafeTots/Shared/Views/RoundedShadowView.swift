//
//  RoundedShadowView.swift
//
//  Created by Md. Mehedi Hasan on 6/12/21.
//

import UIKit

class RoundedShadowView: BaseView {
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.19
        view.layer.cornerRadius = 8.0
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Add all your subsequent subviews to your contentsLayer
    let contentsLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //var radius: CGFloat = 6.0
    
    override func setupView() {
        backgroundColor = UIColor.clear
        addSubview(mainView)
        mainView.addSubview(contentsLayer)
        
        //mainView.layer.cornerRadius = radius
        //contentsLayer.layer.cornerRadius = radius
    }
    
    override func setupLayout() {
        
        mainView.verticalAnchors == self.verticalAnchors + 4.0.dynamic
        mainView.horizontalAnchors == self.horizontalAnchors + 4.0.dynamic
        contentsLayer.edgeAnchors == mainView.edgeAnchors
        
    }
}
