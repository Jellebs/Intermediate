//
//  Array+Extension.swift
//  SwiftUI - Stocks App
//
//  Created by Jesper Bertelsen on 12/04/2021.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
