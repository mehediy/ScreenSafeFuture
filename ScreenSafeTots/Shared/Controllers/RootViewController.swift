//
//  RootViewController.swift
//
//  Created by Md. Mehedi Hasan on 26/7/22.

import UIKit

class RootViewController: BaseViewController {
    
    var containerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    
    let statusView: BaseView = BaseView.with {
        $0.backgroundColor = Theme.Color.redRibbon
    }
    
    let statusLabel: BaseLabel = BaseLabel.with {
        $0.text = "No Connection. Check your internet connection."
        $0.font = Theme.Font.normal.withSize(11.0.dynamic)
        $0.textColor =  UIColor.white
        $0.textAlignment = .center
    }
    
    //var height: NSLayoutConstraint?
    var heightStatusLC: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        view.addSubview(statusView)
        statusView.addSubview(statusLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        
        containerView.topAnchor == view.topAnchor
        containerView.horizontalAnchors == view.horizontalAnchors
        
        statusView.topAnchor == containerView.bottomAnchor
        statusView.horizontalAnchors == view.horizontalAnchors
        statusView.bottomAnchor == view.bottomAnchor
        heightStatusLC = statusView.heightAnchor == getStatusHeightAndHideLabel(status: ReachabilityManager.shared.status)
        
        statusLabel.topAnchor == statusView.topAnchor
        statusLabel.horizontalAnchors == statusView.horizontalAnchors + 16.0.dynamic
        statusLabel.heightAnchor == 20.0.dynamic
    }
    
    
    override func setupController() {
        super.setupController()
        
        ReachabilityManager.shared.observable.bind { [weak self] reachabilityType in
            
            self?.showStatusBar(status: reachabilityType.status, completion: {
                if reachabilityType.status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.hideStatusBar(completion: nil)
                    }
                }
            })
        }
        
    }
    
    private func showStatusBar(status: Bool, completion: (()-> Void)?) {
        
        view.layoutIfNeeded()
        
        self.heightStatusLC?.constant = statusHeight
        
        if status {
            statusView.backgroundColor = Theme.Color.pastelGreen
            statusLabel.text = "You are back online."
            
        } else {
            statusView.backgroundColor = Theme.Color.redRibbon
            statusLabel.text = "No Connection. Check your internet connection."
        }
        
        statusLabel.isHidden = false
                
        UIView.animate(withDuration: 0.5, animations: { [weak self] () -> Void in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            
        }) { completed in
            if completed {
                completion?()
            }
        }
    }
    
    
    private func hideStatusBar(completion: (()-> Void)?) {
        
        view.layoutIfNeeded()
        
        self.heightStatusLC?.constant = 0
        UIView.animate(withDuration: 0.5, animations: { [weak self] () -> Void in
            self?.view.layoutIfNeeded()
        }) { [weak self] completed in
            if completed {
                self?.statusLabel.isHidden = true
                completion?()
            }
        }
    }
    
    
    var statusHeight: CGFloat {
        return DeviceUtility.isNotchFamily ? 40.0.dynamic : 20.0.dynamic
    }
    
    
    func getStatusHeightAndHideLabel(status: Bool) -> CGFloat {
        
        guard !status else {
            statusLabel.isHidden = true
            return 0
        }
        statusLabel.isHidden = false
        return statusHeight
    }
    
}
