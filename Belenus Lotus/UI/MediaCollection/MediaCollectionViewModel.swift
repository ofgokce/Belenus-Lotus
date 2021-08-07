//
//  MediaCollectionViewModel.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import Foundation

extension MediaCollectionViewController {
    class ViewModel {
        enum MediaType {
            case movies
            case series
        }
        
        var title: String {
            switch type {
            case .movies: return "Movies"
            case .series: return "Series"
            }
        }
        var tabBarImageName: String {
            switch type {
            case .movies: return "film"
            case .series: return "tv"
            }
        }
        var tabBarSelectedImageName: String {
            switch type {
            case .movies: return "film.fill"
            case .series: return "tv.fill"
            }
        }
        var searchBarPlaceholder: String {
            switch type {
            case .movies: return "Search Movies"
            case .series: return "Search Series"
            }
        }
        
        private let type: MediaType
        private let mediator: AnyMediaCollectionMediator
        
        private var mediaHandler: (() -> Void)?
        private var errorHandler: ((String) -> Void)?
        
        private(set) var genres: [String] = []
        private(set) var selectedGenre: String? = nil
        private(set) var posters: [String] = [] { didSet { mediaHandler?() } }
        
        init(_ type: MediaType,
             genreHandler: @escaping () -> Void,
             mediaHandler: @escaping () -> Void,
             errorHandler: @escaping (String) -> Void) {
            self.type = type
            
            switch type {
            case .movies: mediator = MoviesMediator()
            case .series: mediator = SeriesMediator()
            }
            
            self.mediaHandler = mediaHandler
            self.errorHandler = errorHandler
            
            fetchGenres(genreHandler)
        }
        
        deinit {
            mediaHandler = nil
            errorHandler = nil
        }
        
        func setSelectedGenre(to genre: String) {
            if genre == "All Genres" {
                selectedGenre = nil
            } else {
                selectedGenre = genre
            }
            discover()
        }
        
        func discover() {
            mediator.getGenres { [weak self] (genres) in
                self?.mediator.setCollectionType(to: .discover(genre: genres.first(where: {$0.name == self?.selectedGenre})?.id),
                                                 completion: self?.handleResult(_:) ?? {_ in})
            }
        }
        
        func topRated() {
            mediator.setCollectionType(to: .topRated, completion: handleResult(_:))
        }
        
        func search(_ key: String) {
            mediator.setCollectionType(to: .search(key: key), completion: handleResult(_:))
        }
        
        func next() {
            mediator.getMedia(handleResult(_:))
        }
        
        func selectedMediaAt(row: Int, in vc: MediaCollectionViewController) {
            let detailVC: MediaDetailViewController
            switch type {
            case .movies: detailVC = MediaDetailViewController.create(withMovieId: mediator.getMedia(at: row)?.id ?? 0)
            case .series: detailVC = MediaDetailViewController.create(withSeriesId: mediator.getMedia(at: row)?.id ?? 0)
            }
            vc.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        func getImageSize(forScreenWidth screenWidth: Double) -> (width: Double, height: Double) {
            let width = (screenWidth - 30) / 2
            let height = width * (3/2)
            return (width, height)
        }
        
        private func fetchGenres(_ completion: @escaping () -> Void) {
            
            func convertGenres(_ genres: [Genre]) {
                self.genres = []
                for genre in genres where genre.name != nil { self.genres.append(genre.name!) }
                completion()
            }
            
            mediator.getGenres { genres in convertGenres(genres) }
        }
        
        private func handleResult(_ result: Result<[AnyMedia], Error>) {
            switch result {
            case .success(let media):
                var posters: [String] = []
                for item in media where item.posterPath != nil {
                    posters.append(item.posterPath!)
                }
                self.posters = posters
            case .failure(let error):
                errorHandler?(error.localizedDescription)
            }
        }
    }
}
