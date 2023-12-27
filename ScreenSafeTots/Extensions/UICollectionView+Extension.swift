//
//  UICollectionView+Extension.swift
//
//  Created by Md. Mehedi Hasan on 27/10/20.
//

import UIKit

extension UICollectionView {
    func addTopBackgroundView(viewColor: UIColor) {
        var frame = bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = viewColor
        addSubview(view)
    }
}
