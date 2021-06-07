//
//  MoviesMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import Foundation

class MoviesMediator: MediaCollectionMediator<Movie> {
    
    private var movie: Movie?
    
    func getMovie(withId id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        self.fetchMovie(id, completion: completion)
    }
    private func fetchMovie(_ id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        TMDBManager.shared.request(.init(medium: .movie, request: .details(id: id))) { [self] (result: Result<Movie, Error>) in
            switch result {
            case let .success(movie):
                self.movie = movie
                fetchCredits(id) {
                    completion(.success(self.movie!))
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    private func fetchCredits(_ id: Int, completion: @escaping () -> Void) {
        TMDBManager.shared.request(.init(medium: .movie, request: .credits(id: id))) { [self] (result: Result<Credits, Error>) in
            switch result {
            case let .success(credits):
                self.movie?.credits = credits
                completion()
            case .failure: completion()
            }
        }
    }
}
