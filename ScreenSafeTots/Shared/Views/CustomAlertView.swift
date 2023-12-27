//
//  CustomAlertView.swift
//
//  Created by MD RUBEL on 25/7/22.
//

import UIKit

class CustomAlertView: UIView, Modal {
    
    var backgroundView: UIView {
        return self
    }
    
    let modalView: UIView = with(UIView()) {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let mainStackView = with(UIStackView()){
        $0.axis = .vertical
        $0.spacing = 20.dynamic
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let labelStackView = with(UIStackView()){
        $0.axis = .vertical
        $0.spacing = 8.dynamic
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let buttonStackView = with(UIStackView()){
        $0.spacing = 8.dynamic
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.bold.withSize(18.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.type = .multiline
        $0.textAlignment = .center
    }
    
    private let subTitleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.labelSecondary
        $0.type = .multiline
        $0.textAlignment = .center
    }
    
    private let title: String?
    private let subTitle: String?
    private let buttons: [CustomAlertButton]
    private let axis: NSLayoutConstraint.Axis?
    
    init(title: String?, subTitle: String, buttons: [CustomAlertButton], axis: NSLayoutConstraint.Axis? = nil) {
        
        self.title = title
        self.subTitle = subTitle
        self.buttons = buttons
        self.axis = axis
        
        super.init(frame: UIScreen.main.bounds)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for button in buttons {
            
            let width = max(button.intrinsicContentSize.width, modalView.frame.width * 0.6)
            
            button.heightAnchor == 36.dynamic
            button.widthAnchor == width.dynamic
        }
    }
    
    private func setupView() {
        
        backgroundColor = Theme.Color.backgroundOpaque
        addSubview(modalView)
        
        modalView.addSubview(mainStackView)
        modalView.layer.cornerRadius = 12.0.dynamic
        
        if let title = title {
            titleLabel.text = title
            labelStackView.addArrangedSubview(titleLabel)
        }
        
        if let subTitle = subTitle {
            subTitleLabel.text = subTitle
            labelStackView.addArrangedSubview(subTitleLabel)
        }
        
        if !labelStackView.arrangedSubviews.isEmpty {
            mainStackView.addArrangedSubview(labelStackView)
        }
        
        if !buttons.isEmpty {
            
            buttons.forEach { button in
                buttonStackView.addArrangedSubview(button)
            }
            
            if let axis = axis {
                buttonStackView.axis = axis
                
            } else if buttons.count == 1 || buttons.count == 2 {
                buttonStackView.axis = .horizontal
                
            } else {
                buttonStackView.axis = .vertical
            }
            
            mainStackView.addArrangedSubview(buttonStackView)
        }
    }
    
    private func setupLayout() {
        
        modalView.widthAnchor == min(340, frame.width * 0.75).dynamic
        modalView.centerXAnchor == centerXAnchor
        modalView.centerYAnchor == centerYAnchor - 20.dynamic
        
        mainStackView.horizontalAnchors == modalView.horizontalAnchors + 16.dynamic
        mainStackView.verticalAnchors == modalView.verticalAnchors + 32.dynamic
    }
}



class CustomAlertButton: UIButton {
    
    enum CustomAlertButtonType {
        case cancel
        case confirm
    }
    
    private let title: String
    private let titleColor: UIColor
    private let bgColor: UIColor
    private let font: UIFont
    private let eventCallback: (() -> Void)?
    private let type: CustomAlertButtonType
    private let borderSetup: CustomAlertBorderSetup?
    
    init(title: String, action: (() -> Void)?, type: CustomAlertButtonType, titleColor: UIColor, bgColor: UIColor, font: UIFont = Theme.Font.medium.withSize(15.dynamic), borderSetup: CustomAlertBorderSetup? = nil) {
        
        self.title = title
        self.titleColor = titleColor
        self.bgColor = bgColor
        self.font = font
        self.eventCallback = action
        self.type = type
        self.borderSetup = borderSetup
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = font
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        if borderSetup != nil || bgColor == .white {
            
            layer.cornerRadius = borderSetup?.cornerRadius ?? 6.0.dynamic
            layer.borderWidth = borderSetup?.borderWidth ?? 1.0.dynamic
            layer.borderColor = borderSetup?.borderColor?.cgColor ?? Theme.Color.primary.cgColor
            
        } else {
            layer.cornerRadius = 6.0.dynamic
        }
    }
    
    @objc private func buttonTapped() {
        
        if type == .cancel {
            var parent = superview
            
            while let v = parent, !v.isKind(of: CustomAlertView.self) {
                parent = v.superview
            }
            
            (parent as? CustomAlertView)?.dismiss(animated: true)
        }
        
        eventCallback?()
    }
}



class CustomAlertBorderSetup {
    
    let borderColor: UIColor?
    let borderWidth: CGFloat?
    let cornerRadius: CGFloat?
    
    internal init(borderColor: UIColor?, borderWidth: CGFloat?, cornerRadius: CGFloat?) {
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
    }
}
