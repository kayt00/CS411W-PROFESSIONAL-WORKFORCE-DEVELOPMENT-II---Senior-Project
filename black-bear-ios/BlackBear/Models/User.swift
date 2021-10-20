//
//  User.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 4/3/21.
//

import Foundation

// User model based off UserAccount table in db
struct User: Identifiable, Codable {
    var id = UUID()
    var firstName = ""
    var lastName = ""
    var username = ""
    var password = ""
    var userRole = ""
    var email = ""
    var phone = ""
    var token = ""
    var profile = Profile()

    enum CodingKeys: String, CodingKey {
        // https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
        case token
        case username
        case password
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decode(String.self, forKey: .token)
    }

    init() {
        self.id = UUID()
        self.firstName = ""
        self.lastName = ""
        self.username = ""
        self.password = ""
        self.userRole = ""
        self.email = ""
        self.phone = ""
        self.token = ""
        self.profile = Profile()
    }

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}

struct Profile: Identifiable, Codable {
    var id = UUID()
    var role: UserRole = .admin
    var name: String = "Harry Smith"
    var email: String = "harrythespy@gmail.com"
    var phone: String = "(757)123-4567"
    var hashPassword: String = "xgh4hkkagbj6"
    var weeklyAlertsOn = true
    var monthlyAlertsOn = true
    var smsAlertsOn = true
}
