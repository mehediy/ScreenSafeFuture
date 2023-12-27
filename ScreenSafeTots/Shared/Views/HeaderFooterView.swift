//
//  HeaderFooterView.swift
//
//  Created by Md. Mehedi Hasan on 5/9/21.
//

import UIKit

protocol ViewLayout {
    
    func layout(on view: UIView)
    
    init()
}


class HeaderFooterView: UITableViewHeaderFooterView {

    let titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.medium.withSize(17.dynamic)
        $0.type = .multiline
        $0.textColor = Theme.Color.header
        $0.textAlignment = .left
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        
        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 16
        titleLabel.topAnchor == contentView.topAnchor + 16.0.dynamic
        titleLabel.bottomAnchor == contentView.bottomAnchor - 8.0.dynamic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HeaderFooterHolderView<Layout : ViewLayout>: UITableViewHeaderFooterView {
    
    let layout: Layout
    
    override init(reuseIdentifier: String?) {
        self.layout = Layout()
        super.init(reuseIdentifier: reuseIdentifier)
        layout.layout(on: contentView) // important!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TopTableHeaderView: UITableViewHeaderFooterView {

    let topEmptyView: BaseView = BaseView.with {
        $0.backgroundColor = Theme.Color.primary
    }
    
    var containerView: BaseView = BaseView.with {
        $0.backgroundColor = UIColor.white
    }
    
    var titleLabel: BaseLabel = BaseLabel.with {
        $0.font = Theme.Font.normal.withSize(15)
        $0.textColor = Theme.Color.boulder
        $0.textAlignment = .left
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.contentView.backgroundColor = .white
        
        addSubview(topEmptyView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        topEmptyView.topAnchor == topAnchor
        topEmptyView.horizontalAnchors == horizontalAnchors
        topEmptyView.heightAnchor == 6.0
        
        //containerView.edgeAnchors == edgeAnchors
        containerView.topAnchor == topEmptyView.bottomAnchor
        containerView.horizontalAnchors == horizontalAnchors
        containerView.bottomAnchor == bottomAnchor
        
        titleLabel.topAnchor == containerView.topAnchor + 12.0
        titleLabel.horizontalAnchors == containerView.horizontalAnchors + 16
        //titleLabel.centerYAnchor == centerYAnchor
        
        containerView.roundTopCorners(radius: 12.0)
    }
}
