//
//  PresentationEnvironment.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 3/12/21.
//

import SwiftUI

struct PresentationKey: EnvironmentKey {
    static let defaultValue: [Binding<Bool>] = []
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey] }
        set { self[PresentationKey] = newValue }
    }
}
