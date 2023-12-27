//
//  BaseViewController.swift
//
//  Created by Md. Mehedi Hasan on 26/7/22.

import UIKit

class BaseViewController: UIViewController {

//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }
    
    open func setupController() { }
    open func setupView() { }
    open func setupLayout() { }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //self.initialize()
        self.setupView()
        self.setupLayout()
        self.setupController()
        //self.controller.value = .didLoad
    }

}
