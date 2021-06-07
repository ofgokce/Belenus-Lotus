//
//  AnyMedia.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 22.05.2021.
//

import Foundation

protocol AnyMedia: Codable {
    var id: Int? { get }
    var title: String? { get }
    var originalTitle: String? { get }
    var tagline: String? { get }
    var status: String? { get }
    var language: String? { get }
    var genres: [Genre]? { get }
    var credits: Credits? { get }
    var overview: String? { get }
    var runtime: Int? { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
    var voteAverage: Double? { get }
    var voteCount: Int? { get }
    var nsfw: Bool? { get }
}
