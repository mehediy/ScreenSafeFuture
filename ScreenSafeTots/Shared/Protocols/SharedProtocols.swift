//
//  SharedProtocols.swift
//
//  Created by Md. Mehedi Hasan on 6/7/20.


import UIKit

// MARK: - NibBased

/// Provide mixins for easy loading of uiview from nib file
protocol NibBased {
    static var nibName: String { get }
    static func instantiate() -> Self
}

extension NibBased {
    /// Name of the nib file from which UIView will be instantiated
    /// Must override this property if nib name is different from UIView's name
    static var nibName: String {
        return "\(Self.self)"
    }

}

extension NibBased where Self: UIView {

    /// This method instantiate a uiview from nib file
    /// - Returns: UIView
    static func instantiate() -> Self  {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        guard let view = nib?.first as? Self else {
            fatalError("Can't load view \(Self.self) from nib \(nibName)")
        }
        return view
    }
}

extension NibBased where Self: UIViewController {

    /// This method instantiate a uiview from nib file
    /// - Returns: UIViewController
    static func instantiate() -> Self  {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: nibName), bundle: nil)
        }
        return instantiateFromNib()
    }
}
