//
//  LearnView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/3/23.
//

import UIKit

//enum LearnEvent: Int {
//    case weblink
//    case pdf
//    case video
//}


class LearnView: BaseView {


    lazy var weblinkButton: BaseButton = BaseButton.with {
        $0.setImage(UIImage(systemName: "link"), for: .normal)
        $0.setTitle("Website Links", for: .normal)
        $0.titleLabel?.font = Theme.Font.medium.withSize(15.0.dynamic)
        $0.tintColor = Theme.Color.link
        $0.setTitleColor(Theme.Color.label, for: .normal)
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.19
        $0.layer.cornerRadius = 8.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 3
        $0.centerImageAndButton(6, imageOnTop: false, imageSize: CGSize(width: 30.dynamic, height: 30.dynamic))
        $0.addTarget(self, action: #selector(weblinkButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var pdfButton: BaseButton = BaseButton.with {
        $0.setImage(UIImage(systemName: "doc.text"), for: .normal)
        $0.setTitle("PDF files", for: .normal)
        $0.titleLabel?.font = Theme.Font.medium.withSize(15.0.dynamic)
        $0.tintColor = Theme.Color.link
        $0.setTitleColor(Theme.Color.label, for: .normal)
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.19
        $0.layer.cornerRadius = 8.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 3
        $0.centerImageAndButton(6, imageOnTop: false, imageSize: CGSize(width: 30.dynamic, height: 30.dynamic))
        $0.addTarget(self, action: #selector(pdfButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var videoButton: BaseButton = BaseButton.with {
        $0.setImage(UIImage(systemName: "film"), for: .normal)
        $0.setTitle("Video", for: .normal)
        $0.titleLabel?.font = Theme.Font.medium.withSize(15.0.dynamic)
        $0.tintColor = Theme.Color.link
        $0.setTitleColor(Theme.Color.label, for: .normal)
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.19
        $0.layer.cornerRadius = 8.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 3
        $0.centerImageAndButton(6, imageOnTop: false, imageSize: CGSize(width: 30.dynamic, height: 30.dynamic))
        $0.addTarget(self, action: #selector(videoButtonTapped(_:)), for: .touchUpInside)
    }
    
    private let buttonStackView = ScreenSafeTots.with(UIStackView()){
        $0.spacing = 12.dynamic
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var eventCallback: ((LearningResourceType) -> Void)?

    
    override func setupView() {
        
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(weblinkButton)
        buttonStackView.addArrangedSubview(pdfButton)
        buttonStackView.addArrangedSubview(videoButton)
//        self.addSubview(weblinkButton)
//        self.addSubview(pdfButton)
//        self.addSubview(videoButton)
    }

    var textViewHeightConstraint: NSLayoutConstraint?
    
    override func setupLayout() {
        
        buttonStackView.verticalAnchors == self.verticalAnchors + 12.dynamic
        buttonStackView.horizontalAnchors == self.horizontalAnchors + 16.dynamic
        
        weblinkButton.heightAnchor ==  weblinkButton.widthAnchor
        pdfButton.heightAnchor ==  pdfButton.widthAnchor
        videoButton.heightAnchor ==  videoButton.widthAnchor
        
//        weblinkButton.heightAnchor == 60.dynamic
//        weblinkButton.widthAnchor == 60.dynamic
//        
//        pdfButton.heightAnchor == 60.dynamic
//        pdfButton.widthAnchor == 60.dynamic
//
//        videoButton.heightAnchor == 60.dynamic
//        videoButton.widthAnchor == 60.dynamic
//        
        
//        weblinkButton.topAnchor == self.topAnchor + 12.0.dynamic
//        weblinkButton.leftAnchor == self.leftAnchor + 28.0.dynamic
//        weblinkButton.bottomAnchor == self.bottomAnchor - 12.0.dynamic
//        weblinkButton.heightAnchor == 40
//        
//        pdfButton.centerXAnchor == self.centerXAnchor
//        pdfButton.centerYAnchor == weblinkButton.centerYAnchor
//        pdfButton.heightAnchor == 40
//
//        videoButton.rightAnchor == self.rightAnchor - 28.0.dynamic
//        videoButton.centerYAnchor == weblinkButton.centerYAnchor
//        videoButton.heightAnchor == 40
    }
    
    func configure(callbackClosure: ((LearningResourceType) -> Void)?) {
        self.eventCallback = callbackClosure

        //badgeView.isHidden = !menuType.showBadge
    }
    
    
    //MARK: - ACTION
    @objc func weblinkButtonTapped(_ sender: Any) {
        eventCallback?(.website)
    }
    
    @objc func pdfButtonTapped(_ sender: Any) {
        eventCallback?(.pdf)
    }

    @objc func videoButtonTapped(_ sender: Any) {
        eventCallback?(.video)
    }
}
