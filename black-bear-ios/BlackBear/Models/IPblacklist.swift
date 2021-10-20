//
//  IPblacklist.swift
//  BlackBear
//
//  Created by ktayl023 on 2/9/21.
//

import Foundation

#warning("TODO: Implement correct data types")
#warning("TODO: Evaluate if any of these can be consts")
#warning("TODO: Remove hardcoded default values")
struct Blacklist: Identifiable {
    var id = UUID() //Wasn't sure how to properly identify each country, I'm assuming by IP but I didn't know how to initialize it
    var countryName: String
    var countryIP: String = "111.222.2.22"
}
