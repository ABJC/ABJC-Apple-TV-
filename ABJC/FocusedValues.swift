//
//  FocusedValues.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import Foundation
import JellyKit
import SwiftUI

struct FocusedItemKey : FocusedValueKey {
    typealias Value = API.Models.Item
}
extension FocusedValues {
    var selectedItem: FocusedItemKey.Value? {
            get { self[FocusedItemKey.self] }
            set { self[FocusedItemKey.self] = newValue }
    }
}
