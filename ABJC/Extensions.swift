//
//  Extensions.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import Foundation

extension Array where Element: Hashable {
    public var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
