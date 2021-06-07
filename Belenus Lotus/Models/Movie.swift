//
//  Movie.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

struct Movie: AnyMedia, Codable {
    let id: Int?
    let title: String?
    let originalTitle: String?
    let tagline: String?
    let status: String?
    let language: String?
    let genres: [Genre]?
    var credits: Credits?
    let overview: String?
    let runtime: Int?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let nsfw: Bool?
    
    let releaseDate: String?
    let budget: Int?
    let revenue: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, tagline, status, genres, credits, overview
        case originalTitle = "original_title"
        case language = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case nsfw = "adult"
        case runtime, budget, revenue
        case releaseDate = "release_date"
    }
}
