//
//  UnderlinedTextField.swift
//
//  Created by Md. Mehedi Hasan on 28/12/20.
//

import UIKit

class UnderlinedTextField: BaseTextField {
    
    let animationDuration = 0.2
    var titleLabel = UILabel()
    var showLabelText: Bool = true
    
    // MARK:- Properties
    override var accessibilityLabel:String? {
        get {
            if let txt = text , txt.isEmpty {
                return titleLabel.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override var placeholder:String? {
        didSet {
            titleLabel.text = placeholder
            titleLabel.sizeToFit()
        }
    }
    
    override var attributedPlaceholder:NSAttributedString? {
        didSet {
            titleLabel.text = attributedPlaceholder?.string
            titleLabel.sizeToFit()
        }
    }
    
    var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            titleLabel.font = titleFont
            titleLabel.sizeToFit()
        }
    }
    
    var hintYPadding:CGFloat = 0.0
    
    var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = titleLabel.frame
            r.origin.y = titleYPadding
            titleLabel.frame = r
        }
    }
    
    var defaultColor: UIColor = Theme.Color.separator {
        didSet {
            if !isFirstResponder {
                titleLabel.textColor = defaultColor
            }
        }
    }
    
    var highlightedColor: UIColor = Theme.Color.primaryLight {
        didSet {
            if isFirstResponder {
                titleLabel.textColor = highlightedColor
            }
        }
    }
    
    var padding = UIEdgeInsets(top: 0, left: 12.0.dynamic, bottom: 0, right: 5)
    
    var updateAutofillForPhoneNumber: Bool = false
    var showWarningForPhoneNumber: Bool = false
    var textFieldCountWhenBeginEditing = 0
    
    var shouldReturnCallback: ((UnderlinedTextField) -> Bool)?
    
    private var shouldHighlightWarning: Bool {
        if showWarningForPhoneNumber {
            if let phoneNumber = text?.trim(newLine: true) {
                if phoneNumber.hasPrefix("+") || phoneNumber.hasPrefix("+88") || phoneNumber.hasPrefix("88") {
                    return true
                }
            }
        }
        return false
    }
    
    let bottomLine = UIView()
    var bottomLineBottomAnchor: NSLayoutConstraint?
    
    required init() {
        super.init()
        print("UnderlinedTextField init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard showLabelText else { return }
        
        setTitlePositionForTextAlignment()
        let isResp = isFirstResponder
        if let txt = text , !txt.isEmpty && isResp {
            titleLabel.textColor = shouldHighlightWarning ? Theme.Color.negation : highlightedColor
        } else {
            titleLabel.textColor = shouldHighlightWarning ? Theme.Color.negation : defaultColor
        }
        // Should we show or hide the title label?
        if let txt = text , txt.isEmpty {
            // Hide
            hideTitle(isResp)
        } else {
            // Show
            showTitle(isResp)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //return bounds.inset(by: padding)
        
        var rect = super.textRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            var top = ceil(titleLabel.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            rect = rect.inset(by: UIEdgeInsets(top: top, left: 12.0.dynamic, bottom: 0.0, right: 5.0))
        } else {
            rect = rect.inset(by: padding)
        }
        return rect.integral
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        //return bounds.inset(by: padding)
        
        var rect = super.textRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            var top = ceil(titleLabel.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            rect = rect.inset(by: UIEdgeInsets(top: top, left: 12.0.dynamic, bottom: 0.0, right: 5.0))
        } else {
            rect = rect.inset(by: padding)
        }
        
        return rect.integral
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //return bounds.inset(by: padding)
        
        var rect = super.textRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            var top = ceil(titleLabel.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            rect = rect.inset(by: UIEdgeInsets(top: top, left: 12.0.dynamic, bottom: 0.0, right: 5.0))
        } else {
            rect = rect.inset(by: padding)
        }
        
        return rect.integral
    }
    
    override func setupView() {
        super.setupView()
        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultColor
        self.addSubview(bottomLine)
        
        self.addTarget(self, action: #selector(self.numberTextChanged(_:)), for: .editingChanged)
        
        //Top Placeholder Title
        borderStyle = UITextField.BorderStyle.none
        // Set up title label
        titleLabel.alpha = 0.0
        titleLabel.font = titleFont
        titleLabel.textColor = defaultColor
        if let str = placeholder , !str.isEmpty {
            titleLabel.text = str
            titleLabel.sizeToFit()
        }
        self.addSubview(titleLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        bottomLine.horizontalAnchors == horizontalAnchors
        bottomLineBottomAnchor = bottomLine.bottomAnchor == bottomAnchor
        bottomLine.heightAnchor == 1.0
    }
    
    func setHighlightedColor() {
        bottomLine.backgroundColor = highlightedColor
        rightView?.tintColor = highlightedColor
    }
    
    func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultColor
        rightView?.tintColor = defaultColor
    }
    
    @objc private func numberTextChanged(_ textField: UITextField) {
        if updateAutofillForPhoneNumber {
            updateNumberFromTextField()
        }
    }
    
    private func updateNumberFromTextField() {
        if updateAutofillForPhoneNumber, let number = self.text {
            let difference = abs(number.count - textFieldCountWhenBeginEditing)
            let isTextFromSuggestion = difference > 1 && !number.isEmpty
            if isTextFromSuggestion {
                DispatchQueue.main.async {
                    let cleanedPhoneNumber = number.cleanPhoneNumber()
                    if number != cleanedPhoneNumber {
                        self.text = cleanedPhoneNumber
                        self.textFieldCountWhenBeginEditing = cleanedPhoneNumber.count
                    }
                }
            }
            textFieldCountWhenBeginEditing = number.count
        }
    }
    
    internal func maxTopInset() -> CGFloat {
        if let fnt = font {
            return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
        }
        return 0
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        let r = textRect(forBounds: bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.center {
            x = r.origin.x + (r.size.width * 0.5) - titleLabel.frame.size.width
            if x < r.origin.x {
                x = r.origin.x
            }
        } else if textAlignment == NSTextAlignment.right {
            x = r.origin.x + r.size.width - titleLabel.frame.size.width
        }
        titleLabel.frame = CGRect(x:x, y:titleLabel.frame.origin.y, width:titleLabel.frame.size.width, height:titleLabel.frame.size.height)
    }
    
    fileprivate func showTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.titleLabel.alpha = 1.0
            var r = self.titleLabel.frame
            r.origin.y = self.titleYPadding
            self.titleLabel.frame = r
        }, completion:nil)
    }
    
    fileprivate func hideTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            self.titleLabel.alpha = 0.0
            var r = self.titleLabel.frame
            r.origin.y = self.titleLabel.font.lineHeight + self.hintYPadding
            self.titleLabel.frame = r
        }, completion:nil)
    }
}

extension UnderlinedTextField {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if updateAutofillForPhoneNumber {
            if let text = textField.text {
                textFieldCountWhenBeginEditing = text.count
            }
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setHighlightedColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setDefaultUnderlineColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shouldReturnCallback = shouldReturnCallback {
            return shouldReturnCallback(self)
        }
        return false
    }
    
}
