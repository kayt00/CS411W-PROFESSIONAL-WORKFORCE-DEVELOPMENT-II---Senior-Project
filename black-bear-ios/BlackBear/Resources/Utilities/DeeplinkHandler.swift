//
//  DeeplinkHandler.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 3/12/21.
//

import SwiftUI

class DeeplinkHandler {
    enum Deeplink {
        case addDevice
    }

    func manage(url: URL) -> Deeplink? {
        guard
            url.scheme == "blackbear",
            url.host == "MFA"
        else { return nil }

        let components = url.pathComponents
        let action = components.first(where: { $0 != "/" })

        switch action {
            case "AddDevice": return .addDevice
            default: return nil
        }
    }
}

struct DeeplinkKey: EnvironmentKey {
    typealias Value = DeeplinkHandler.Deeplink?

    static var defaultValue: DeeplinkHandler.Deeplink? {
        return nil
    }
}

extension EnvironmentValues {
    var deeplink: DeeplinkHandler.Deeplink? {
        get {
            self[DeeplinkKey]
        }
        set {
            self[DeeplinkKey] = newValue
        }
    }
}
