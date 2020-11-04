//
//  AlertError.swift
//  ABJC
//
//  Created by Noah Kamara on 04.11.20.
//

import Foundation

public struct AlertError: Identifiable {
    public var id: Date
    var title: String
    var description: String
    
    public init(_ title: String, _ descr: String) {
        self.id = Date()
        self.title = title
        self.description = descr
    }
}
