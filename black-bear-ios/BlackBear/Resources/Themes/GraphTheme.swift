//
//  GraphTheme.swift
//  BlackBear
//
//  Created by ktayl023 on 2/13/21.
//

import Foundation
import SwiftUI

struct GraphTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(Font.custom("Avenir", size: 30))
    }
}

struct GraphTitleUnits: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(Font.custom("Avenir", size: 12))
    }
}

struct GraphPickerStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 10)
            .font(Font.custom("Avenir", size: 18))
    }
}

struct GraphCategoriesStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(Font.custom("Avenir", size: 14))
    }
}

struct GraphNavigationTabLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.success)
            .font(Font.custom("Avenir", size: 16))
    }
}

   
