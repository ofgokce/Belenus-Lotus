//
//  Genre.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

struct Genres: Codable {
    let genres: [Genre]?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
