//
//  VLAN.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import Foundation

enum Vlan: String {
    case computerAndPhone = "Computers / Phones"
    case smartHome = "Smart Home"
    case gamingAndTv = "Gaming / TV"
    case guest = "Guests"
}

enum VlanID: Int, Codable {
    case unassigned = 0
    case guest = 1
    case smartHome
    case computerAndPhone
    case gamingAndTv
}

struct VLAN: Identifiable {
    var id = UUID()
    var systemName: String
    var roleType: String
    var registeredDevices: Int
    var createdBy: String
    var createdOn: String
    var avgDailyUploadTraffic: Float = 3.6
    var avgDailyDownloadTraffic: Float = 538.2
    var peakUploadBandwidth: Float = 20
    var peakDownloadBandwidth: Float = 100
}

// vlan model based off Vlan table in db
struct vlan: Identifiable, Codable {
    let id: Int
    let VlanName: String
    let UploadLimitMB: Int
    let DownloadLimitMB: Int
    let PeakUploadLimitMBps: Int
    let PeakDownloadLimitMBps: Int
    let Creator: User.ID
    let CreationTimeStamp: Date = Date()

    enum CodingKeys: String, CodingKey {
        case id = "VlanRecordIdentifier"
        case VlanName
        case UploadLimitMB
        case DownloadLimitMB
        case PeakUploadLimitMBps
        case PeakDownloadLimitMBps
        case Creator
//        case CreationTimestamp
    }
    
    #warning("TODO: Add Date decoder")
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        VlanName = try values.decode(String.self, forKey: .VlanName)
        UploadLimitMB = try (values.decodeIfPresent(Int?.self, forKey: .UploadLimitMB) ?? 250)!
        DownloadLimitMB = try (values.decodeIfPresent(Int?.self, forKey: .UploadLimitMB) ?? 400)!
        PeakUploadLimitMBps = try (values.decodeIfPresent(Int?.self, forKey: .UploadLimitMB) ?? 300)!
        PeakDownloadLimitMBps = try (values.decodeIfPresent(Int?.self, forKey: .UploadLimitMB) ?? 500)!
       // DownloadLimitMB = try values.decode(Int.self, forKey: .DownloadLimitMB)
       // PeakUploadLimitMBps = try values.decode(Int.self, forKey: .PeakUploadLimitMBps)
       // PeakDownloadLimitMBps = try values.decode(Int.self, forKey: .PeakDownloadLimitMBps)
        Creator = try (values.decodeIfPresent(UUID?.self, forKey: .Creator) ?? UUID())!
//        CreationTimestamp = try values.decodeIfPresent(Date.self, forKey: .ConnectedSince) ?? Date()
    }
}

/*
 Data returned from endpoint call
 {
    "VlanRecordIdentifier": 1,
    "VlanName": "Guest",
    "UploadLimitMB": 802,
    "DownloadLimitMB": 308,
    "PeakUploadLimitMBps": 287,
    "PeakDownloadLimitMBps": 238,
    "Creator": null,
    "CreationTimestamp": "2021-04-15T21:52:13.000Z"
 }
 */
