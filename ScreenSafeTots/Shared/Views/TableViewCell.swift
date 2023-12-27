//
//  TableViewCell.swift
//
//  Created by Md. Mehedi Hasan on 2/12/21.
//

import UIKit

class TableViewCell<T: UIView>: UITableViewCell, BaseViewProtocol, ReusableView {
    
    lazy var customView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupLayout()
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.selectionStyle = .none
        contentView.addSubview(customView)
    }
    
    func setupLayout() {
        customView.edgeAnchors == contentView.edgeAnchors
    }
}
