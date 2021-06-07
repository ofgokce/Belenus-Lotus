//
//  SeriesDetailViewModel.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 1.06.2021.
//

import Foundation
import UIKit

extension SeriesDetailViewController {
    struct ViewModel {
        
        enum SectionData {
            case textBased(cells: [(text: String, detail: String?)])
            case imageBased(cellData: [(id: Int?, imagePath: String)])
        }
        
        private(set) var tableViewData: [(title: String, data: SectionData)] = []
        
        let backdropPath: String
        let tagline: String
        
        private let title: String
        private let year: String
        var titleAttributed: NSAttributedString {
            let title = NSMutableAttributedString(string: self.title + " ", attributes: [.font : UIFont.systemFont(ofSize: 22, weight: .semibold)])
            let year = NSAttributedString(string: "(\(self.year))", attributes: [.font : UIFont.systemFont(ofSize: 22, weight: .light)])
            title.append(year)
            return title
        }
        
        init(with data: Series) {
            backdropPath = data.backdropPath ?? ""
            title = data.title ?? ""
            year = String(data.firstAirDate?.prefix(4) ?? "")
            tagline = data.tagline ?? ""
            tableViewData = cellData(from: data)
        }
        
        mutating func updateRecommended(with recommended: [Series]) {
            if let index = tableViewData.firstIndex(where: {$0.title == "Recommended Also"}) {
                tableViewData[index] = cellData(forRecommended: recommended)
            } else {
                tableViewData.append(cellData(forRecommended: recommended))
            }
        }
        
        func getImageSize(forScreenWidth screenWidth: Double) -> (width: Double, height: Double) {
            let width = (screenWidth - 30) / 2
            let height = width * (3/2)
            return (width, height)
        }
        
        private func cellData(from data: Series) -> [(title: String, data: SectionData)] {
            var sections: [(title: String, data: SectionData)] = []
            if let overview = cellData(forOverview: data.overview ?? "") { sections.append(overview) }
            if let createdBy = cellData(forCreators: data.createdBy ?? []) { sections.append(createdBy) }
            if let cast = cellData(forCast: data.credits?.cast ?? []) { sections.append(cast) }
            if let crew = cellData(forCrew: data.credits?.crew ?? []) { sections.append(crew) }
            if let seasons = cellData(forSeasons: data.seasons ?? []) { sections.append(contentsOf: seasons) }
            return sections
        }
        
        private func cellData(forOverview overview: String) -> (title: String, data: SectionData)? {
            if overview.isEmpty { return nil }
            return (title: "Overview", data: .textBased(cells: [(text: overview, detail: nil)]))
        }
        
        private func cellData(forCreators creators: [Person]) -> (title: String, data: SectionData)? {
            var creatorsData: [(text: String, detail: String?)] = []
            for creator in creators where creator.name != nil {
                creatorsData.append((text: creator.name!, detail: nil))
            }
            if creatorsData.isEmpty { return nil }
            return (title: "Created By", data: .textBased(cells: creatorsData))
        }
        
        private func cellData(forCast cast: [Person]) -> (title: String, data: SectionData)? {
            var castData: [(text: String, detail: String?)] = []
            for person in cast.prefix(4) where person.name != nil{
                castData.append((text: person.name!, detail: person.character))
            }
            if castData.isEmpty { return nil }
            return (title: "Cast", data: .textBased(cells: castData))
        }
        
        private func cellData(forCrew crew: [Person]) -> (title: String, data: SectionData)? {
            var crewData: [(text: String, detail: String?)] = []
            let crew = crew.sorted(by: {$0.order ?? 0 < $1.order ?? 0})
            for person in crew.prefix(4) where person.name != nil && person.job != nil {
                crewData.append((text: person.name!, detail: person.job!))
            }
            if crewData.isEmpty { return nil }
            return (title: "Crew", data: .textBased(cells: crewData))
        }
        
        private func cellData(forSeasons seasons: [Series.Season]) -> [(title: String, data: SectionData)]? {
            var seasonData: [(title: String, data: SectionData)] = []
            for season in seasons
            where season.seasonNumber != nil {
                var episodesData: [(text: String, detail: String?)] = []
                for episode in season.episodes ?? []
                where episode.episodeNumber != nil {
                    var text = "Episode \(episode.episodeNumber!)"
                    var detail = ""
                    if episode.name != nil { text.append(": \(episode.name!)") }
                    if episode.airDate != nil { detail.append("Aired: \(episode.airDate!)") }
                    episodesData.append((text, detail))
                }
                if episodesData.isEmpty { episodesData.append((text: "No data found", detail: nil))}
                seasonData.append((title: "Season \(season.seasonNumber!)", data: .textBased(cells: episodesData)))
            }
            if seasonData.isEmpty { return nil }
            return seasonData
        }
        
        private func cellData(forRecommended recommended: [Series]) -> (title: String, data: SectionData) {
            var recommendedData: [(id: Int?, imagePath: String)] = []
            for item in recommended where item.id != nil && item.posterPath != nil {
                recommendedData.append((id: item.id, imagePath: item.posterPath!))
            }
            return (title: "Recommended Also", data: .imageBased(cellData: recommendedData))
        }
    }
}

