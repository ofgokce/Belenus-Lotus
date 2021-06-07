//
//  MediaCollectionMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 27.05.2021.
//

import Foundation

class MediaCollectionMediator<T: AnyMedia> {
    
    enum CollectionType {
        case discover(genre: Int?)
        case topRated
        case search(key: String)
        case recommended(forMovieWithId: Int)
    }
    
    private var collectionType: CollectionType = .discover(genre: nil) {
        didSet {
            self.media = []
            self.page = 0
        }
    }
    private var medium: TMDBManager.API.Medium {
        switch T.self {
        case is Movie.Type: return .movie
        case is Series.Type: return .tv
        default: fatalError("MediaCollectionMediator set to an unsupported generic type")
        }
    }
    
    private let genresMediator = GenresMediator()
    private var genres: [Genre] = []
    private var media: [T] = []
    private var page: Int = 0
    
    func setCollectionType(to collectionType: CollectionType, completion: @escaping (Result<[T], Error>) -> Void) {
        self.collectionType = collectionType
        self.getMedia(completion)
    }
    
    func getMedia(_ completion: @escaping (Result<[T], Error>) -> Void) {
        self.page += 1
        switch self.collectionType {
        case let .discover(genre):
            fetch(.init(medium: medium, request: .discover(page: page, genre: genre)), completion: completion)
        case .topRated:
            fetch(.init(medium: medium, request: .topRated(page: page)), completion: completion)
        case let .search(key):
            fetch(.init(medium: medium, request: .search(key: key, page: page)), completion: completion)
        case let .recommended(id):
            fetch(.init(medium: medium, request: .recommendations(id: id, page: page)), completion: completion)
        }
    }
    
    func getGenres(completion: @escaping ([Genre]) -> Void) {
        if genres.isEmpty {
            genresMediator.getGenres(of: medium) { [unowned self] (genres: [Genre]) in
                self.genres = genres
                completion(genres)
            }
        } else {
            completion(genres)
        }
    }
    
    private func fetch(_ request: TMDBManager.API, completion: @escaping (Result<[T], Error>) -> Void) {
        TMDBManager.shared.request(request) { [unowned self] (result: Result<Base<[T]>, Error>) in
            switch result {
            case let .success(data):
                self.media.append(contentsOf: data.results ?? [])
                completion(.success(self.media))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
