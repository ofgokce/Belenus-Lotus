//
//  TMDBManager.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 21.05.2021.
//

import Foundation

class TMDBManager {
    static let shared = TMDBManager()
    private init() {}
    
    private let key = "API_KEY" // Bu anahtar TMDb'nin gizlilik politikaları gereğince saklanmıştır.
    
    func request<T: Codable>(_ request: API, completion: @escaping (Result<T, Error>) -> Void) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        
        RestfulManager.shared.request(urlRequest, completion: completion)
    }
    
    func request(_ image: Image) -> String {
        return image.url
    }
}

extension TMDBManager {
    struct API {
        private static let base = "https://api.themoviedb.org/3" //v3
        enum Medium: String { case tv, movie }
        enum Request {
            case details(id: Int)
            case credits(id: Int)
            case discover(page: Int = 1, genre: Int?)
            case genres
            case recommendations(id: Int, page: Int = 1)
            case providers(id: Int)
            case search(key: String, page: Int = 1)
            case topRated(page: Int = 1)
            case episode(_ episode: Int, season: Int, seriesId: Int)
            case season(_ season: Int, seriesId: Int)
        }
        
        private let medium: Medium
        private let request: Request
        
        init(medium: Medium, request: Request) {
            self.medium = medium
            self.request = request
        }
        
        var url: URL {
            if let urlQueryAllowedString = (TMDBManager.API.base + path + query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: urlQueryAllowedString) { return url } else { fatalError() }
        }
        
        // . . .
        
        private var path: String {
            switch request {
            case let .details(id): return "/\(medium.rawValue)/\(id)"
            case let .credits(id): return "/\(medium.rawValue)/\(id)/credits"
            case .discover: return "/discover/\(medium.rawValue)"
            case .genres: return "/genre/\(medium.rawValue)/list"
            case let .recommendations(id,_): return "/\(medium.rawValue)/\(id)/recommendations"
            case let .providers(id): return "/\(medium.rawValue)/\(id)/watch/providers"
            case .search: return "/search/\(medium.rawValue)"
            case .topRated: return "/\(medium.rawValue)/top_rated"
            case let .episode(episode, season, showId): return "/tv/\(showId)/season/\(season)/episode/\(episode)"
            case let .season(season, showId): return "/tv/\(showId)/season/\(season)"
            }
        }
        
        private var query: String {
            switch request {
            case let .discover(page, genre): return getQueryString(for: ["page" : page, "with_genres" : genre])
            case let .search(key, page): return getQueryString(for: ["query" : key, "page" : page])
            case let .topRated(page) : return getQueryString(for: ["page" : page])
            default: return getQueryString(for: [:])
            }
        }
        
        private func getQueryString(for items: [String : Any?]) -> String {
            var str = "?"
            for item in items where item.value != nil {
                str.append("\(item.key)=\(item.value!)&")
            }
            return String(str.dropLast())
        }
    }
}
// MARK: - Image
extension TMDBManager {
    enum Image {
        private static let base = "https://image.tmdb.org/t/p/"

        case backdrop(size: Int = 2, path: String)
        case logo(size: Int = 4, path: String)
        case poster(size: Int = 6, path: String)
        case profile(size: Int = 1, path: String)
        case still(size: Int = 4, path: String)

        fileprivate var url: String {
            switch self {
            case let .backdrop(size, path),
                 let .logo(size, path),
                 let .poster(size, path),
                 let .profile(size, path),
                 let .still(size, path):
                return Image.base + "\(self.sizes[size])/\(path)"
            }
        }

        private var sizes: [String] {
            switch self {
            case .backdrop: return ["w300", "w780", "w1280", "original"]
            case .logo: return ["w185", "w300", "w500", "original"]
            case .poster: return ["w342", "w500", "w780", "original"]
            case .profile: return ["w45", "w185", "h632", "original"]
            case .still: return ["w92", "w185", "w300", "original"]
            }
        }
    }
}
