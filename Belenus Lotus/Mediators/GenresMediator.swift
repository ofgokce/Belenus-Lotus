//
//  GenresMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import Foundation


class GenresMediator {
    private var genres: [Genre] = []
    
    func getGenres(of medium: TMDBManager.API.Medium, completion: @escaping (Result<[Genre], Error>) -> Void) {
        if genres.isEmpty {
            TMDBManager.shared.request(.init(medium: medium, request: .genres)) { [unowned self] (result: Result<Genres, Error>) in
                switch result {
                case let .success(data):
                    self.genres = data.genres ?? []
                    completion(.success(genres))
                case let .failure(error): completion(.failure(error))
                }
            }
        } else {
            completion(.success(genres))
        }
    }
    func getGenres(of medium: TMDBManager.API.Medium, completion: @escaping ([Genre]) -> Void) {
        getGenres(of: medium) { (result: Result<[Genre], Error>) in
            switch result {
            case let .success(genres): completion(genres)
            case .failure: completion([])
            }
        }
    }
}
