//
//  ActionSheetSelectCell.swift
//
//  Created by Md. Mehedi Hasan on 28/6/21.


import UIKit

class ActionSheetSelectCell: UITableViewCell, ReusableView {
    
    let cellContainerView: BaseView = BaseView.with {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4.0
    }
    
    lazy var checkmarkImageView: BaseImageView = BaseImageView.with {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.labelSecondary
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "square_unchecked_mono")
    }
   
    /*
    let checkbox = with(Checkbox()) {
//        $0.checkmarkStyle = .tick
//        $0.borderStyle = .square
//        $0.checkmarkColor = Theme.Color.primary
//        $0.checkedBorderColor = Theme.Color.primary
//        $0.uncheckedBorderColor = Theme.Color.labelSecondary
        
//        $0.baseColor = .white
//        $0.checkColor = Theme.Color.primary
//
//        $0.containerColor = Theme.Color.labelSecondary
//        $0.containerWidth = 2.0
//        $0.isRadioButton = false
//        $0.isOn = false
//        $0.isRadiobox = false
//        $0.shouldAnimate = false
//        $0.shouldFillContainer = false
    }*/
    
    let titleLabel: BaseLabel = BaseLabel.with {
        $0.textColor = Theme.Color.labelSecondary
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.minimumScaleFactor = 0.6
        $0.adjustsFontSizeToFitWidth = true
    }
    

    
    //Private Properties
    private var cellIndexPath: IndexPath!
    private var callbackClosure: ((IndexPath, Bool) -> Void)?
    //private var selected: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }
    
    func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {
        
        let action: () -> Void = { [weak self] in
            self?.cellContainerView.backgroundColor = selectedOrHighlighted ? Theme.Color.selectedBackground : .white
            //self?.titleImageView.tintColor = selectedOrHighlighted ? Theme.Color.primary : Theme.Color.labelSecondary
            if self?.isSelected == false {
                self?.titleLabel.textColor = selectedOrHighlighted ? Theme.Color.primary : Theme.Color.labelSecondary
            }
        }
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(checkmarkImageView)
        cellContainerView.addSubview(titleLabel)
        //checkbox.addTarget(self, action: #selector(checkboxValueChanged(_:)), for: .valueChanged)
        
        cellContainerView.topAnchor == contentView.topAnchor + 1.0
        cellContainerView.horizontalAnchors == contentView.horizontalAnchors + 8.0.dynamic
        cellContainerView.bottomAnchor == contentView.bottomAnchor - 1.0
        
        checkmarkImageView.leftAnchor == cellContainerView.leftAnchor + 16.0.dynamic
        checkmarkImageView.widthAnchor == 20.0.dynamic
        checkmarkImageView.heightAnchor == 20.0.dynamic
        checkmarkImageView.centerYAnchor == cellContainerView.centerYAnchor
        
        titleLabel.leftAnchor == checkmarkImageView.rightAnchor + 12.0.dynamic
        titleLabel.rightAnchor == cellContainerView.rightAnchor - 16.0.dynamic
        titleLabel.centerYAnchor == cellContainerView.centerYAnchor
    }
    
    //func configure(indexPath: IndexPath, title: String, selected: Bool, callbackClosure: ((_ cellIndexPath: IndexPath, _ checked: Bool) -> Void)?) {
    func configure(title: String, selected: Bool) {
        //cellIndexPath = indexPath
        //self.callbackClosure = callbackClosure
        //checkbox.isOn = selected
        
        let selectedColor = selected ? Theme.Color.primary : Theme.Color.labelSecondary
        let imageName = selected ? "square_checked_mono" : "square_unchecked_mono"
        titleLabel.text = title
        titleLabel.textColor = selectedColor

        checkmarkImageView.image = UIImage(named: imageName)
        checkmarkImageView.tintColor = selectedColor
        self.isSelected = selected
    }
    
//    @objc func checkboxValueChanged(_ sender: Any){
//        callbackClosure?(cellIndexPath, checkbox.isOn)
//    }
    
}
