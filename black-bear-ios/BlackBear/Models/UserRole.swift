//
//  UserRole.swift
//  BlackBear
//
//  Created by ktayl023 on 2/11/21.
//

import Foundation

enum UserRole: String, Codable {
    case admin = "Administrator"
    case standard = "Standard User"
    case guest = "Guest"
}

