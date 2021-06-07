//
//  MoviesViewModel.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import Foundation

//extension MoviesViewController {
//    struct ViewModel {
//        static let title = "Movies"
//        static let tabBarImageName = "film"
//        static let tabBarSelectedImageName = "film.fill"
//        static let searchBarPlaceholder = "Search Movies"
//
//        private let allGenresTitle = "All Genres"
//        private var genreList: [(id: Int, name: String)] = []
//        private var selectedGenre: (id: Int, name: String)? = nil
//        private(set) var cellData: [(id: Int, posterPath: String)] = []
//
//        func getSelectedGenreName() -> String {
//            return selectedGenre == nil ? allGenresTitle : selectedGenre!.name
//        }
//        func getSelectedGenreId() -> Int? {
//            return selectedGenre?.id
//        }
//        func getGenreList() -> [String] {
//            var names: [String] = []
//            for genre in genreList { names.append(genre.name) }
//            names.insert(allGenresTitle, at: 0)
//            return names
//        }
//        func getImageSize(forScreenWidth screenWidth: Double) -> (width: Double, height: Double) {
//            let width = (screenWidth - 30) / 2
//            let height = width * (3/2)
//            return (width, height)
//        }
//        mutating func setSelectedGenre(_ genre: String) {
//            if genre == "All Genres" {
//                self.selectedGenre = nil
//            } else {
//                self.selectedGenre = genreList.first(where: {$0.name == genre})
//            }
//        }
//        mutating func update(_ movies: [Movie], completion: () -> Void = {}) {
//            self.cellData = []
//            for movie in movies where movie.id != nil && movie.posterPath != nil {
//                self.cellData.append((movie.id!, movie.posterPath!))
//            }
//            completion()
//        }
//        mutating func update(_ genres: [Genre], completion: () -> Void = {}) {
//            self.genreList = []
//            for genre in genres where genre.id != nil && genre.name != nil {
//                genreList.append((genre.id!, genre.name!))
//            }
//            completion()
//        }
//    }
//}

extension MoviesViewController {
    struct ViewModel {
        
        private var genreList: [(id: Int, name: String)] = []
        private var selectedGenre: (id: Int, name: String)? = nil
        private(set) var cellData: [(id: Int, posterPath: String)] = []
        
        private let updateHandler: () -> Void
        private let errorHandler: (Error) -> Void
        
        init(withUpdateHandler updateHandler: @escaping () -> Void,
             errorHandler: @escaping (Error) -> Void) {
            self.updateHandler = updateHandler
            self.errorHandler = errorHandler
        }
        
        mutating func update(withResults results: Result<[Movie], Error>) {
            switch results {
            case let .success(movies):
                self.cellData = []
                for movie in movies where movie.id != nil && movie.posterPath != nil {
                    self.cellData.append((movie.id!, movie.posterPath!))
                }
                updateHandler()
            case let .failure(error):
                errorHandler(error)
            }
        }
        mutating func update(withResults results: Result<[Genre], Error>) {
            switch results {
            case let .success(genres):
                self.genreList = []
                for genre in genres where genre.id != nil && genre.name != nil {
                    genreList.append((genre.id!, genre.name!))
                }
                updateHandler()
            case let .failure(error):
                errorHandler(error)
            }
        }
    }
}
