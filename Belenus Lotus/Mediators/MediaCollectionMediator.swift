//
//  MediaCollectionMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 27.05.2021.
//

import Foundation

enum MediaCollectionSourceType {
    case discover(genre: Int?)
    case topRated
    case search(key: String)
    case recommended(forMovieWithId: Int)
}

protocol AnyMediaCollectionMediator {
    func setCollectionType(to collectionType: MediaCollectionSourceType, completion: @escaping (Result<[AnyMedia], Error>) -> Void)
    func getGenres(completion: @escaping ([Genre]) -> Void)
    func getMedia(_ completion: @escaping (Result<[AnyMedia], Error>) -> Void)
    func getMedia(at index: Int) -> AnyMedia?
    func getMedia(withId: Int, completion: @escaping (Result<AnyMedia, Error>) -> Void)
}

class MediaCollectionMediator<T: AnyMedia>: AnyMediaCollectionMediator {
    
    private var collectionType: MediaCollectionSourceType = .discover(genre: nil) {
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
    
    func getGenres(completion: @escaping ([Genre]) -> Void) {
        if genres.isEmpty {
            genresMediator.getGenres(of: medium) { [weak self] (genres: [Genre]) in
                self?.genres = genres
                completion(genres)
            }
        } else {
            completion(genres)
        }
    }
    func setCollectionType(to collectionType: MediaCollectionSourceType, completion: @escaping (Result<[AnyMedia], Error>) -> Void) {
        setCollectionType(to: collectionType) { (result: Result<[T], Error>) in
            switch result {
            case .success(let media): completion(.success(media))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    func getMedia(_ completion: @escaping (Result<[AnyMedia], Error>) -> Void) {
        getMedia { (result: Result<[T], Error>) in
            switch result {
            case .success(let media): completion(.success(media))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getMedia(at index: Int) -> AnyMedia? {
        let media: T? = getMedia(at: index)
        return media
    }
    
    func getMedia(withId: Int, completion: @escaping (Result<AnyMedia, Error>) -> Void) {
        preconditionFailure("This method must be overridden")
    }
    
    
    private func setCollectionType(to collectionType: MediaCollectionSourceType, completion: @escaping (Result<[T], Error>) -> Void) {
        self.collectionType = collectionType
        self.getMedia(completion)
    }
    
    private func getMedia(_ completion: @escaping (Result<[T], Error>) -> Void) {
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
    
    private func getMedia(at index: Int) -> T? {
        return media.count > index ? media[index] : nil
    }
    
    private func fetch(_ request: TMDBManager.API, completion: @escaping (Result<[T], Error>) -> Void) {
        TMDBManager.shared.request(request) { [weak self] (result: Result<Base<[T]>, Error>) in
            switch result {
            case let .success(data):
                self?.media.append(contentsOf: data.results ?? [])
                completion(.success(self?.media ?? []))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
