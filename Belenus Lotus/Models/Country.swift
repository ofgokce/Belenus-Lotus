//
//  CountryAndLanguage.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

struct Country: Codable {
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case id = "iso_3166_1"
        case name
    }
}
