//
//  TopRoundedHeaderView.swift
//
//  Created by Md. Mehedi Hasan on 8/12/21.
//

import UIKit

class TopRoundedHeaderView: UITableViewHeaderFooterView {

    let roundedView: BaseView = BaseView.with {
        $0.backgroundColor = .white
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = Theme.Color.primary
        
        contentView.addSubview(roundedView)
        roundedView.edgeAnchors == contentView.edgeAnchors
        
        let screenSize = UIScreen.main.bounds.size
        let frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.9)
        roundedView.roundTopCorners(radius: 12.0, frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
