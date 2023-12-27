//
//  SingleLineInfoCardCell.swift
//
//  Created by Mehedi Hasan on 01/12/2019.
//

import UIKit

class SingleLineInfoCardCell: UITableViewCell, NibReusableView {
    @IBOutlet weak var containedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    
    let accessoryImage: BaseImageView = BaseImageView.with {
        $0.image = UIImage(systemName: "chevron.right")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Theme.Color.primary
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        containedView.addSubview(accessoryImage)
        //accessoryImage.leftAnchor == titleLabel.rightAnchor + 8.dynamic
        accessoryImage.centerYAnchor == containedView.centerYAnchor
        accessoryImage.heightAnchor == 16.dynamic
        accessoryImage.widthAnchor == 16.dynamic
        accessoryImage.rightAnchor == containedView.rightAnchor - 12.0.dynamic
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(highlighted, animated: animated)
        super.setHighlighted(highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        setAsSelectedOrHighlighted(selected, animated: animated)
        super.setSelected(selected, animated: animated)
    }

    private func setAsSelectedOrHighlighted(_ selectedOrHighlighted: Bool, animated: Bool) {

        let action: () -> Void = { [weak self] in
            // Set animatable properties
            self?.containedView?.backgroundColor = selectedOrHighlighted ? UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0): .white
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: action, completion: nil)
        } else {
            action()
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
