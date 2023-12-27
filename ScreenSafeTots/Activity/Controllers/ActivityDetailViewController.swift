//
//  ActivityDetailViewController.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 9/28/23.
//


import UIKit

class ActivityDetailViewController: UIViewController {
    
    let scrollView = with(UIScrollView()) {
        $0.showsHorizontalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    let containerView: BaseView = BaseView.with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var bannerImageView: ScaleAspectFitImageView = with(ScaleAspectFitImageView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        //$0.contentMode = .scaleAspectFit
    }
    
    let titleLabel: BaseLabel = BaseLabel.with {
        $0.textColor = Theme.Color.primary
        $0.font = Theme.Font.bold.withSize(22.0.dynamic)
        $0.type = .multiline
    }
    
    let detailTextView: BaseTextView = BaseTextView.with {
        $0.font = Theme.Font.normal.withSize(17.0.dynamic)
        $0.textColor = Theme.Color.label
        $0.textAlignment = .left
        $0.backgroundColor = UIColor.clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isEditable = false
        $0.isScrollEnabled = false
    }
    
    lazy var actionButton: BaseButton = BaseButton.with {
        $0.setTitle("I have done it!", for: .normal)
        $0.titleLabel?.font = Theme.Font.medium.withSize(17.dynamic)
        $0.setTitleColor(Theme.Color.link, for: .normal)
        $0.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
    }
    
    
    private func setupView() {
        view.backgroundColor = UIColor.white
        //title = billCompanyDetail.companyName
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailTextView)
        
        
        containerView.addSubview(bannerImageView)
        bannerImageView.image = UIImage(named: activity.image ?? "")
        
        titleLabel.text = activity.name
        detailTextView.text = activity.explanation + "\n\n" + activity.impact
        
        containerView.addSubview(actionButton)
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        
        
        let imageName = activity.isFavorite ? "heart.fill" : "heart"

        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        rightBarItem.setTitleTextAttributes([.font: Theme.Font.medium.withSize(18)], for: .normal)
        rightBarItem.setTitlePositionAdjustment(UIOffset(horizontal: 0.0, vertical: 5.0), for: .default)
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func setupLayout() {
        scrollView.edgeAnchors == view.saferAreaLayoutGuide.edgeAnchors
        scrollView.widthAnchor == view.widthAnchor
        
        containerView.edgeAnchors == scrollView.edgeAnchors
        containerView.centerXAnchor == view.centerXAnchor

        bannerImageView.topAnchor == containerView.topAnchor
        bannerImageView.horizontalAnchors == containerView.horizontalAnchors
        bannerImageView.heightAnchor <= view.heightAnchor * 0.5
        
        titleLabel.topAnchor == bannerImageView.bottomAnchor + 24.0.dynamic
        
        
        titleLabel.horizontalAnchors == containerView.horizontalAnchors + 16.0.dynamic
        
        detailTextView.topAnchor == titleLabel.bottomAnchor + 16.0.dynamic
        detailTextView.horizontalAnchors == containerView.horizontalAnchors + 16.0.dynamic
        
        if true {
            actionButton.topAnchor == detailTextView.bottomAnchor + 24.0.dynamic
            actionButton.leftAnchor == containerView.leftAnchor + 16.0.dynamic
            actionButton.bottomAnchor == containerView.bottomAnchor - 32.0.dynamic
        } else {
            detailTextView.bottomAnchor == containerView.bottomAnchor - 32.0.dynamic
        }
    }
    
    
    @objc func actionButtonTapped() {
        
    }
    
    @objc func favoriteButtonTapped() {
        
        activity.isFavorite = !activity.isFavorite
        
        let imageName = activity.isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
}
