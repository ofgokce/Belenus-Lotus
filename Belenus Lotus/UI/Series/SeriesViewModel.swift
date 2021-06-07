//
//  SeriesViewModel.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 27.05.2021.
//

import Foundation

extension SeriesViewController {
    struct ViewModel {
        static let title = "Series"
        static let tabBarImageName = "tv"
        static let tabBarSelectedImageName = "tv.fill"
        static let searchBarPlaceholder = "Search Series"
        
        private let allGenresTitle = "All Genres"
        private var genreList: [(id: Int, name: String)] = []
        private var selectedGenre: (id: Int, name: String)? = nil
        
        private(set) var cellData: [(id: Int, posterPath: String)] = []
        
        func getSelectedGenreName() -> String {
            return selectedGenre == nil ? allGenresTitle : selectedGenre!.name
        }
        
        func getSelectedGenreId() -> Int? {
            return selectedGenre?.id
        }
        
        func getGenreList() -> [String] {
            var names: [String] = []
            for genre in genreList { names.append(genre.name) }
            names.insert(allGenresTitle, at: 0)
            return names
        }
        
        func getImageSize(forScreenWidth screenWidth: Double) -> (width: Double, height: Double) {
            let width = (screenWidth - 30) / 2
            let height = width * (3/2)
            return (width, height)
        }
        
        mutating func setSelectedGenre(_ genre: String) {
            if genre == "All Genres" {
                self.selectedGenre = nil
            } else {
                self.selectedGenre = genreList.first(where: {$0.name == genre})
            }
        }
        
        mutating func update(_ series: [Series], completion: () -> Void = {}) {
            self.cellData = []
            for serie in series where serie.id != nil && serie.posterPath != nil {
                self.cellData.append((serie.id!, serie.posterPath!))
            }
            completion()
        }
        
        mutating func update(_ genres: [Genre], completion: () -> Void = {}) {
            self.genreList = []
            for genre in genres where genre.id != nil && genre.name != nil {
                genreList.append((genre.id!, genre.name!))
            }
            completion()
        }
    }
}
