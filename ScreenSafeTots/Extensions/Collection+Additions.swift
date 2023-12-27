//
//  Collection+Additions.swift
//
//  Created by Md. Mehedi Hasan on 12/8/20.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
