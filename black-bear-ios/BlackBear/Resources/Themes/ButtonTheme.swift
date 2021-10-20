//
//  ButtonTheme.swift
//  BlackBear
//
//  Created by ktayl023 on 2/13/21.
//

import Foundation
import SwiftUI

struct RemoveButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir", size: 12))
            .foregroundColor(.theme)
            .padding()
            .frame(width: 150, height: 35, alignment: .center)
            .background(Color.error)
            .cornerRadius(15.0)
    }
}

struct SFButton: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
    }
}

struct UpdateButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir", size: 12))
            .foregroundColor(.theme)
            .padding()
            .frame(width: 200, height: 35)
            .background(Color.success)
            .cornerRadius(15.0)
    }
}

struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        LoginButton(configuration: configuration)
    }

    struct LoginButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(Font.custom("Avenir", size: 12))
                .foregroundColor(.theme)
                .frame(width: 200, height: 35)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isEnabled ? .success : Color.success.opacity(0.2)))
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)

        }
    }
}
struct ApproveButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir", size: 12))
            .foregroundColor(.theme)
            .padding()
            .frame(width: 125, height: 35)
            .background(Color.success)
            .cornerRadius(15.0)
    }
}

struct DenyButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir", size: 12))
            .foregroundColor(.theme)
            .padding()
            .frame(width: 125, height: 35)
            .background(Color.error)
            .cornerRadius(15.0)
    }
}

struct MFAButtons: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 70, height: 85)
            .background(Color.gray)
            .cornerRadius(12.0)
    }
}

struct MFAGuestButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 285, height: 100)
            .background(Color.gray)
            .cornerRadius(12.0)
    }
}

struct DenyDropDownMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .foregroundColor(Color.error)
            .background(Color.white)
    }
}

