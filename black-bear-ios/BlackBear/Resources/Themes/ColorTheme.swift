//
//  ColorTheme.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//

import SwiftUI

// https://prafullkumar77.medium.com/theming-swiftui-app-with-dark-and-light-mode-support-421468345355
#warning("TODO: Implement style theme across app")

extension Color {

    static var theme: Color  {
        return Color("theme")
    }

    static var error: Color  {
        return Color("error")
    }

    static var success: Color  {
        return Color("success")
    }

    static var warning: Color  {
        return Color("warning")
    }

    static var solidButtonText: Color  {
        return Color("solidButtontext")
    }

    static var textHeaderPrimary: Color  {
        return Color("textHeaderPrimary")
    }

    static var textHeaderSecondary: Color  {
        return Color("textHeaderSecondary")
    }
    
    static var textHeaderTertiary: Color  {
        return Color("textHeaderTertiary")
    }
    
    static var textParagraph: Color  {
        return Color("textParagraph")
    }
    
    static var navigationTab: Color  {
        return Color("navigationTab")
    }
    
    static var sectionHeader: Color  {
        return Color("sectionHeader")
    }
}
