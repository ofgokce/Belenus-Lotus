//
//  Series.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

struct Series: AnyMedia, Codable {
    let id: Int?
    let title: String?
    let originalTitle: String?
    let tagline: String?
    let status: String?
    let language: String?
    let genres: [Genre]?
    var credits: Credits?
    let overview: String?
    var runtime: Int? { return episodeRunTime?.first }
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let nsfw: Bool?
    
    let createdBy: [Person]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let nextEpisodeToAir: Episode?
    var seasons: [Season]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let networks: [Company]?

    enum CodingKeys: String, CodingKey {
        case id, tagline, status, genres, credits, overview
        case title = "name"
        case originalTitle = "original_name"
        case language = "original_language"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case nsfw = "adult"
        
        case networks, seasons
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
    }
}

// MARK: - Season
extension Series {
    struct Season: Codable {
        let airDate: String?
        let episodes: [Episode]?
        let name: String?
        let overview: String?
        let posterPath: String?
        let seasonNumber: Int?

        enum CodingKeys: String, CodingKey {
            case airDate = "air_date"
            case episodes
            case name
            case overview
            case posterPath = "poster_path"
            case seasonNumber = "season_number"
        }
    }
}
// MARK: - Episode
extension Series {
    struct Episode: Codable {
        let airDate: String?
        let episodeNumber: Int?
        let crew: [Person]?
        let id: Int?
        let name, overview, productionCode: String?
        let seasonNumber: Int?
        let stillPath: String?
        let voteAverage: Double?
        let voteCount: Int?

        enum CodingKeys: String, CodingKey {
            case airDate = "air_date"
            case episodeNumber = "episode_number"
            case crew
//            case guestStars = "guest_stars"
            case id, name, overview
            case productionCode = "production_code"
            case seasonNumber = "season_number"
            case stillPath = "still_path"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
}
