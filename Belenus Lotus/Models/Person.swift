//
//  Person.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

struct Person: Codable {
    let id: Int?
    let name: String?
    let job: String?
    let popularity: Double?
    let order: Int?
    let character: String?
    
    enum Job: String {
        case director = "Director"
        case directorOfPhotography = "Director of Photography"
        case editor = "Editor"
        case writer = "Writer"
    }
}

struct Credits: Codable {
    let cast, crew: [Person]?
}
