//
//  DEVICE.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import Foundation

enum ConnectionStatus: String, Codable {
    case connected
    case pendingApproval = "pending_approval"
    case disconnected
}

struct MFADeviceApproval: Codable {
    let deviceId: Int
    let vlan: Int
}

// DEVICE model based off Device table in dB
struct DEVICE: Identifiable, Codable {
    let id: Int
    let DeviceName: String
    let MacAddress: String
    let IPAddress: String
    let status: ConnectionStatus
    let manufacturer: String
    let LastConnected: String
    let ConnectedSince: String
    let UploadLimitMB: Int
    let DownloadLimitMB: Int
    let Creator: Int?
    let CreationTimestamp: String
    var VlanId: VlanID

    enum CodingKeys: String, CodingKey {
        case id = "DeviceRecordIdentifier"
        case DeviceName
        case MacAddress
        case IPAddress
        case status = "Status"
        case manufacturer = "Manufacturer"
        case LastConnected
        case ConnectedSince
        case UploadLimitMB
        case DownloadLimitMB
        case Creator
        case CreationTimestamp
        case VlanId = "Vlan"
    }

    #warning("TODO: Add Date decoder")
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        DeviceName = try values.decode(String.self, forKey: .DeviceName)
        MacAddress = try values.decode(String.self, forKey: .MacAddress)
        IPAddress = try values.decode(String.self, forKey: .IPAddress)
        status = try values.decode(ConnectionStatus.self, forKey: .status)
        manufacturer = try values.decodeIfPresent(String.self, forKey: .manufacturer) ?? "Unknown"
        LastConnected = try values.decodeIfPresent(String.self, forKey: .LastConnected) ?? "Never"
        ConnectedSince = try values.decodeIfPresent(String.self, forKey: .ConnectedSince) ?? "Unknown"
        UploadLimitMB = try values.decode(Int.self, forKey: .UploadLimitMB)
        DownloadLimitMB = try values.decode(Int.self, forKey: .DownloadLimitMB)
        Creator = try values.decodeIfPresent(Int?.self, forKey: .Creator) ?? 1
        CreationTimestamp = try values.decodeIfPresent(String.self, forKey: .CreationTimestamp) ?? "Unknown"
        VlanId = try values.decode(VlanID.self, forKey: .VlanId)
    }

    init() {
        self.id = 0
        self.DeviceName = ""
        self.MacAddress = ""
        self.IPAddress = ""
        self.status = .connected
        self.manufacturer = ""
        self.LastConnected = ""
        self.ConnectedSince = ""
        self.UploadLimitMB = 1
        self.DownloadLimitMB = 1
        self.Creator = 1
        self.CreationTimestamp = ""
        self.VlanId = .unassigned
    }
}
