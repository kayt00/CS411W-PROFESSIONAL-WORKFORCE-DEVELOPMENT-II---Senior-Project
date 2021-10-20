//
//  Honeypot.swift
//  BlackBear
//
//  Created by ktayl023 on 2/9/21.
//

import Foundation

#warning("TODO: Remove hardcoded default values")
struct Honeypot: Identifiable {
    var id = UUID()
    var ip: String = "192.168.1.101"
    var ports = [Port(portNum: 80), Port(portNum: 23)]
    var attackAlertsOn = true
    var removeAttackerOn = true
    var blockAttackOn = true
}
struct Port: Identifiable {
    let id = UUID()
    let portNum: Int
}
