//
//  Sequence+Additions.swift
//
//  Created by Md. Mehedi Hasan on 23/9/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
