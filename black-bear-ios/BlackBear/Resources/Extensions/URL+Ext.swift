//
//  URL+Ext.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 4/3/21.
//

import Foundation

// Source: https://www.swiftbysundell.com/clips/4/

extension URL {
    static var adminUserExists: URL {
        makeForEndpoint("user/admin-user-exists") // GET
    }
    
    static var registerInitialAdmin: URL {
        makeForEndpoint("auth/register-initial-admin") // POST
    }

    static var login: URL {
        makeForEndpoint("auth/login") // POST
    }

    static var users: URL {
        makeForEndpoint("user/all") // GET
    }
    
    static var addUser: URL {
        makeForEndpoint("auth/add-user") // POST
    }
    
    static var userProfile: URL {
        makeForEndpoint("user/user-profile") // GET
    }

    static var devices: URL {
        makeForEndpoint("device/all") // GET
    }

    static var pendingDevices: URL {
        makeForEndpoint("device/pending") // GET
    }

    static var addDevice: URL {
        makeForEndpoint("device/add") // POST
    }

    static var approveDevice: URL {
        makeForEndpoint("device/approve")
    }
    
    static var disconnectDevice: URL {
        makeForEndpoint("device/disconnect") // POST
    }
    
    static var moveDevice: URL {
        makeForEndpoint("device/move") // POST
    }
    
    static func randomDevice(for deviceCount: Int) -> URL {
        makeForEndpoint("randomData/addRandomDevices/\(deviceCount)")
    }
    
    static var vlans: URL {
        makeForEndpoint("vlan/all") // GET
    }

    static var addVlan: URL {
        makeForEndpoint("vlan/add") // POST
    }
    
    static var removeVlan: URL {
        makeForEndpoint("vlan/remove") // POST
    }
   
    static func randomVlans(for vlanCount: Int) -> URL {
        makeForEndpoint("randomData/addRandomVlans/\(vlanCount)")
    }
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: "http://localhost:8000/\(endpoint)")!
    }
}
