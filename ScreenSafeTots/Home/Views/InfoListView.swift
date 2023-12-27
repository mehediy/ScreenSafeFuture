//
//  InfoListView.swift
//  ScreenSafeTots
//
//  Created by Md Mehedi Hasan on 10/10/23.
//

import UIKit

class InfoListView: BaseView {
    
    var activities: [Activity] = []
    var callback: ((Activity) -> Void)?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(InfoCardCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.left = 12.0
        
        return collectionView
    }()
    
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = .white
        //collectionView.backgroundColor = UIColor.white
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.heightAnchor == 100.0.dynamic
        
        collectionView.horizontalAnchors == self.horizontalAnchors
        collectionView.verticalAnchors == self.verticalAnchors + 12.0.dynamic
        //collectionView.heightAnchor == 128.0.dynamic
    }
    
    func configure(activities: [Activity], callbackClosure: ((Activity) -> Void)?) {
        self.activities = activities
        self.callback = callbackClosure

        //badgeView.isHidden = !menuType.showBadge
    }

}


extension InfoListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as InfoCardCell
        if let activity = activities[safe: indexPath.row] {
            cell.configure(with: activity.name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let activity = activities[safe: indexPath.row] {
            callback?(activity)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height * 2
        return CGSize(width: width, height: height)
    }
}
