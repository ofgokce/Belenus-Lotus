//
//  Company.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

struct Company: Codable {
    let name: String?
    let id: Int?
    let logoPath: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case name, id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
