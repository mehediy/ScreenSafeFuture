//
//  ActionSheetViewCell.swift
//
//  Created by Md. Mehedi Hasan on 19/5/21.

import UIKit

class ActionSheetViewCell: UITableViewCell, ReusableView {
    
    lazy var cellContainerView: BaseView = BaseView.with {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4.0
    }
    
    let containerStackView = with(UIStackView()){
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10.0.dynamic
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var titleImageView: BaseImageView = BaseImageView.with {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.labelSecondary
    }
    
    lazy var titleLabel: BaseLabel = BaseLabel.with {
        $0.textColor = Theme.Color.labelSecondary
        $0.font = Theme.Font.medium.withSize(17.0.dynamic)
        $0.minimumScaleFactor = 0.6
        $0.adjustsFontSizeToFitWidth = true
    }
    
    lazy var optionSwitch: BaseSwitch = BaseSwitch.with {
        $0.isOn = false
        $0.onTintColor = Theme.Color.primary
        $0.addTarget(self, action: #selector(switchButtonAction(_:)), for: .valueChanged)
    }
    
    //    lazy var checkmarkImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(named: "done-mono")
    //        //imageView.tintColor = UIColor.clearBlue
    //        imageView.contentMode = .scaleAspectFit
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        return imageView
    //    }()
    
    //Private Properties
    private var cellIndexPath: IndexPath?
    private var switchCallbackClosure: ((IndexPath, Bool) -> Void)?
    private var isEnabled: Bool = true
    
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
        
        guard optionSwitch.isHidden else { return }
        
        let action: () -> Void = { [weak self] in
            self?.cellContainerView.backgroundColor = selectedOrHighlighted ? Theme.Color.selectedBackground : .white
            self?.titleImageView.tintColor = selectedOrHighlighted ? Theme.Color.primary : Theme.Color.labelSecondary
            self?.titleLabel.textColor = selectedOrHighlighted ? Theme.Color.primary : Theme.Color.labelSecondary
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
        cellContainerView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(optionSwitch)
        
        cellContainerView.topAnchor == contentView.topAnchor + 1.0
        cellContainerView.horizontalAnchors == contentView.horizontalAnchors + 8.0.dynamic
        cellContainerView.bottomAnchor == contentView.bottomAnchor - 1.0
        
        containerStackView.horizontalAnchors == cellContainerView.horizontalAnchors + 16.0.dynamic
        containerStackView.centerYAnchor == cellContainerView.centerYAnchor
        
        titleImageView.widthAnchor == 22.0.dynamic
        titleImageView.heightAnchor == 22.0.dynamic
    }
    
    func configure(title: String, titleImage: String?, switchChecked: Bool?, isEnabled: Bool, indexPath: IndexPath,
                   switchCallbackClosure: ((IndexPath, Bool) -> Void)?) {
        
        self.cellIndexPath = indexPath
        self.switchCallbackClosure = switchCallbackClosure
        self.isEnabled = isEnabled
        
        titleLabel.text = title
        
        isUserInteractionEnabled = isEnabled
        if isEnabled {
            titleLabel.alpha = 1.0
            titleImageView.alpha = 1.0
            optionSwitch.alpha = 1.0
        } else {
            titleLabel.alpha = 0.5
            titleImageView.alpha = 0.5
            optionSwitch.alpha = 0.5
        }
        
        if let titleImage = titleImage {
            titleImageView.isHidden = false
            titleImageView.image = UIImage(named: titleImage)
        } else {
            titleImageView.isHidden = true
            titleImageView.image = nil
        }
        
        if let switchChecked = switchChecked {
            optionSwitch.isHidden = false
            optionSwitch.isEnabled = true
            optionSwitch.setOn(switchChecked, animated: false)
        } else {
            optionSwitch.isHidden = true
            optionSwitch.isEnabled = false
        }
    }
    
    @objc func switchButtonAction(_ sender: UISwitch) {
        if let cellIndexPath = cellIndexPath {
            switchCallbackClosure?(cellIndexPath, sender.isOn)
        }
    }
    
    func changeSwitchValue(_ checked: Bool, animated: Bool) {
        optionSwitch.setOn(checked, animated: animated)
    }
    
}

