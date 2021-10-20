//
//  TextTheme.swift
//  BlackBear
//
//  Created by ktayl023 on 2/13/21.
//

import Foundation
import SwiftUI

struct PrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textHeaderPrimary)
            .font(Font.custom("Avenir", size: 24))
    }
}

struct SecondaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textHeaderSecondary)
            .font(Font.custom("Avenir", size: 16))
    }
}

struct MFALabels: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.success)
            .font(Font.custom("Avenir", size: 14))
    }
}

struct MFAGuestLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.success)
            .font(Font.custom("Avenir", size: 18))
    }
}

struct RegisterAdminLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.success)
            .font(Font.custom("Avenir", size: 25))
    }
}

struct RegisterAdminSecondaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.gray)
            .font(Font.custom("Avenir", size: 15))
    }
}


struct TertiaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textHeaderTertiary)
            .font(Font.custom("Avenir", size: 12))
    }
}

struct LabelContents: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textHeaderTertiary)
            .font(Font.custom("Avenir", size: 10))
    }
}

struct MFASectionHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.background(Color.black)
            .foregroundColor(.green)
            .font(Font.custom("Avenir", size: 18))
    }
}

struct PendingApprovalSectionHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.background(Color.black)
            .foregroundColor(.orange)
            .font(Font.custom("Avenir", size: 18))
    }
}

struct SectionHeader: ViewModifier {
    func body(content: Content) -> some View {
            content
                //.background(Color.black)
                .foregroundColor(Color.textHeaderPrimary)
                .font(Font.custom("Avenir", size: 16))
    }
}

struct NavigationTabText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .foregroundColor(Color.textHeaderSecondary)
            .font(Font.custom("Avenir", size: 16))
    }
}

struct NavigationTab: ViewModifier {
    func body(content: Content) -> some View {
        content
        .listRowBackground(Color.navigationTab.opacity(0.9))
    }
}

struct ListRowStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
        .listRowBackground(Color.theme)
        //still figuring out the opacity styling
    }
}

struct TextFieldStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 5)
            .font(Font.custom("Avenir", size: 16))
            .autocapitalization(.words)
            .disableAutocorrection(true)

    }
}

struct OtherTextFieldStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 5)
            .font(Font.custom("Avenir", size: 16))
            .autocapitalization(.none)
            .disableAutocorrection(true)

    }
}

struct SecureFieldStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .background(Color.theme)
            .cornerRadius(5.0)
            .padding(.bottom, 15)
            .shadow(radius: 5, x: 5, y: 5)
            .autocapitalization(.none)
            .disableAutocorrection(true)

    }
}

struct NavBarTitleStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(alignment: .center)

    }
}

struct LoginLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir", size: 35))
            //.fontWeight(.semibold)
            .padding(0.0)
            .foregroundColor(.white)
    }
}
