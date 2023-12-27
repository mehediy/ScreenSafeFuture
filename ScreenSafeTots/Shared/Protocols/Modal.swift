//
//  Modal.swift
//
//  Created by Md. Mehedi Hasan on 6/7/20.


import UIKit

protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView: UIView { get }
    var modalView: UIView { get }
}

extension Modal where Self: UIView {
    func show(animated: Bool){
        self.backgroundView.alpha = 0
        if let topController = UIApplication.topPresentedViewController {
            topController.view.addSubview(self)
        } else {
            print("No topPresentedViewController")
        }
        
        if animated {
            self.modalView.center = CGPoint(x: self.center.x, y: -self.frame.height/2 + self.modalView.frame.height/2)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.modalView.center  = self.center
                self.backgroundView.alpha = 1.0
            }, completion: { (completed) in
                
            })
            
        } else {
            self.backgroundView.alpha = 1.0
            self.modalView.center  = self.center
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                self.backgroundView.alpha = 0
            }
            animator.addCompletion { position in
                if position == .end {
                    self.removeFromSuperview()
                }
            }
            animator.startAnimation()
            
        } else {
            self.removeFromSuperview()
        }
        
    }
}

protocol ActionSheetable {
    func show(animated: Bool, in viewController: UIViewController?)
    func dismiss(animated: Bool)
    var dismissCallback: (() -> Void)? { get set }
    var backgroundView: UIView { get }
    var actionSheetView: UIView { get }
    var actionSheetViewHeight: CGFloat { get }
    var bottomLayoutConstraint: NSLayoutConstraint! { get }
}

extension ActionSheetable where Self: UIView {
    
    func show(animated: Bool, in viewController: UIViewController? = nil) {

        if let topController = viewController ?? UIApplication.topPresentedViewController {
            topController.view.addSubview(self)
            self.edgeAnchors == topController.view.edgeAnchors
            topController.view.layoutIfNeeded()
        }
        
        bottomLayoutConstraint.constant = 0
        self.backgroundView.backgroundColor = UIColor.clear
        
        if animated {
            UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveLinear) { [weak self] in
                //self?.backgroundView.alpha = 1.0
                self?.backgroundView.backgroundColor = Theme.Color.backgroundOpaque
                self?.layoutIfNeeded()
            } completion: { completed in
                
            }
        } else {
            //self.backgroundView.alpha = 1.0
            self.backgroundView.backgroundColor = Theme.Color.backgroundOpaque
            self.layoutIfNeeded()
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            bottomLayoutConstraint.constant = actionSheetViewHeight
            UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveLinear) { [weak self] in
                //self?.backgroundView.alpha = 0
                self?.backgroundView.backgroundColor = UIColor.clear
                self?.layoutIfNeeded()
            } completion: { [weak self] completed in
                if completed {
                    self?.removeFromSuperview()
                    self?.dismissCallback?()
                }
            }
        } else {
            //self.backgroundView.alpha = 0
            self.backgroundView.backgroundColor = UIColor.clear
            self.layoutIfNeeded()
            self.removeFromSuperview()
            self.dismissCallback?()
        }
        
    }
}
