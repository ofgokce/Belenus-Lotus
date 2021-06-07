//
//  SeriesMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import Foundation

class SeriesMediator: MediaCollectionMediator<Series> {
    
    private var series: Series?
    
    func getSeries(withId id: Int, completion: @escaping (Result<Series, Error>) -> Void) {
        self.fetchSeries(id, completion: completion)
    }
    private func fetchSeries(_ id: Int, completion: @escaping (Result<Series, Error>) -> Void) {
        TMDBManager.shared.request(.init(medium: .tv, request: .details(id: id))) { [self] (result: Result<Series, Error>) in
            switch result {
            case var .success(series):
                series.seasons = []
                self.series = series
                fetchSeasons(id, numberOfSeasons: series.numberOfSeasons ?? 0) {
                    fetchCredits(id) {
                        completion(.success(self.series!))
                    }
                }
            case let .failure(error): completion(.failure(error))
            }
        }
    }
    private func fetchSeasons(_ id: Int, numberOfSeasons: Int, seasonNo: Int = 1, completion: @escaping () -> Void) {
        if seasonNo > numberOfSeasons { return completion() }
        TMDBManager.shared.request(.init(medium: .tv, request: .season(seasonNo, seriesId: id))) { [self] (result: Result<Series.Season, Error>) in
            switch result {
            case let .success(season):
                self.series?.seasons?.append(season)
                fetchSeasons(id, numberOfSeasons: numberOfSeasons, seasonNo: seasonNo + 1, completion: completion)
            case .failure:
                completion()
            }
        }
    }
    private func fetchCredits(_ id: Int, completion: @escaping () -> Void) {
        TMDBManager.shared.request(.init(medium: .tv, request: .credits(id: id))) { [self] (result: Result<Credits, Error>) in
            switch result {
            case let .success(credits):
                self.series?.credits = credits
                completion()
            case .failure: completion()
            }
        }
    }
}
