//
//  UIButton+Additions.swift
//
//  Created by Md. Mehedi Hasan on 6/7/20.
//

import UIKit

extension UIButton {
    
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool, imageSize: CGSize? = nil) {
        
        guard let imageView = self.currentImage, let titleText = self.titleLabel?.text else { return }
        
        var imageViewSize = imageView.size
        if let imageSize = imageSize, let image = imageView.resizeImage(imageSize) {
            setImage(image, for: .normal)
            imageViewSize = image.size
        }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        self.titleEdgeInsets = UIEdgeInsets(top: (imageViewSize.height + gap) * sign, left: -imageViewSize.width, bottom: 0, right: 0);
        
        let titleSize = titleText.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func addBlurEffect(style: UIBlurEffect.Style = .light, cornerRadius: CGFloat = 0, padding: CGFloat = 0) {
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear

        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurView, at: 0)
        blurView.edgeAnchors == self.edgeAnchors + padding

        if let imageView = self.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
}

