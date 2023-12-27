//
//  PagingTitleMenuViewCell.swift
//  PagingKit
//
//  Copyright (c) 2017 Kazuhiro Hayashi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit


/// Basic style of cell
/// - center text
/// - emphasize text to focus color
class PagingTitleMenuViewCell: PagingMenuViewCell {
    
    static var sizingCell = PagingTitleMenuViewCell(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    ///  The text color when selecred
    var focusColor = UIColor.white {
        didSet {
            if isSelected {
                imageView.tintColor = focusColor
                titleLabel.textColor = focusColor
            }
        }
    }
    
    /// The normal text color.
    var normalColor = UIColor.black {
        didSet {
            if !isSelected {
                imageView.tintColor = normalColor
                titleLabel.textColor = normalColor
            }
        }
    }
    
    var labelWidth: CGFloat {
        return stackView.bounds.width
    }
    
    let titleLabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let topContainerView = { () -> UIView in
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView = { () -> UIImageView in
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.isHidden = false
        } else {
            imageView.image = image
            imageView.isHidden = true
        }
    }
    
    let badgeLabel = { () -> UILabel in
        let label = UILabel()
        label.font = Theme.Font.light.withSize(9)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.isHidden = true
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    func setBadgeCount(_ count: Int?) {
        if let count = count {
            if count == 0 {
                badgeLabel.text = ""
            } else {
                badgeLabel.text = String(count)
            }
            badgeLabel.isHidden = false
        } else {
            badgeLabel.text = ""
            badgeLabel.isHidden = true
        }
    }
    
    let stackView = UIStackView()
    
    var spacing: CGFloat {
        get {
            stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }
    
    func calcIntermediateLabelSize(with leftCell: PagingTitleMenuViewCell, percent: CGFloat) -> CGFloat {
        let diff = (labelWidth - leftCell.labelWidth) * percent
        return leftCell.labelWidth + diff
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        badgeLabel.heightAnchor == 10
        badgeLabel.widthAnchor >= 10
        imageView.addSubview(badgeLabel)
        badgeLabel.centerYAnchor == imageView.topAnchor
        badgeLabel.centerXAnchor == imageView.rightAnchor
        topContainerView.addSubview(imageView)
        
        imageView.heightAnchor == 24
        imageView.widthAnchor == 24
        imageView.centerAnchors == topContainerView.centerAnchors
        
        backgroundColor = .white
        stackView.axis = .vertical
        stackView.addArrangedSubview(topContainerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.spacing = 4
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints([
            anchorLabel(from: stackView, to: self, attribute: .top),
            anchorLabel(from: stackView, to: self, attribute: .leading, .greaterThanOrEqual),
            anchorLabel(from: self, to: stackView, attribute: .trailing, .greaterThanOrEqual),
            anchorLabel(from: self, to: stackView, attribute: .bottom),
            anchorLabel(from: stackView, to: self, 0, attribute: .centerX)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.tintColor = focusColor
                titleLabel.textColor = focusColor
            } else {
                imageView.tintColor = normalColor
                titleLabel.textColor = normalColor
            }
        }
    }
    
    
    /// syntax sugar of NSLayoutConstraint for titleLabel (Because this library supports iOS8, it cannnot use NSLayoutAnchor.)
    private func anchorLabel(from fromItem: Any, to toItem: Any, _ constant: CGFloat = 8, attribute: NSLayoutConstraint.Attribute, _ relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: fromItem,
            attribute: attribute,
            relatedBy: relatedBy,
            toItem: toItem,
            attribute: attribute,
            multiplier: 1,
            constant: constant
        )
    }
}
