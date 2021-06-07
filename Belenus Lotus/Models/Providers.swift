//
//  Providers.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import Foundation

struct Providers: Codable {
    let AR, AT, AU, BE, BR, CA, CH, CL, CO, CZ, DE, DK, EC, FI, FR, GB, HU, ID, IE, IN, IT, JP, LT, MX, MY, NL, NO, NZ, PE, PH, PL, PT, RO, RU, SE, SG, TH, TR, US, VE, ZA: Data?
    
    struct Data: Codable {
        let flatrate: [Provider]
        let rent: [Provider]
        let buy: [Provider]
        
        struct Provider: Codable {
            let logoPath: String
            let name: String
            
            enum CodingKeys: String, CodingKey {
                case logoPath = "logo_path"
                case name = "provider_name"
            }
        }
    }
}
