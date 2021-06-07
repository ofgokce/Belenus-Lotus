//
//  MovieDetailViewModel.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 1.06.2021.
//

import Foundation
import UIKit

extension MovieDetailViewController {
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
        
        init(with data: Movie) {
            backdropPath = data.backdropPath ?? ""
            title = data.title ?? ""
            year = String(data.releaseDate?.prefix(4) ?? "")
            tagline = data.tagline ?? ""
            tableViewData = cellData(from: data)
        }
        
        mutating func updateRecommended(with recommended: [Movie]) {
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
        
        private func cellData(from data: Movie) -> [(title: String, data: SectionData)] {
            var sections: [(title: String, data: SectionData)] = []
            if let overview = cellData(forOverview: data.overview ?? "") { sections.append(overview) }
            if let cast = cellData(forCast: data.credits?.cast ?? []) { sections.append(cast) }
            if let crew = cellData(forCrew: data.credits?.crew ?? []) { sections.append(crew) }
            return sections
        }
        
        private func cellData(forOverview overview: String) -> (title: String, data: SectionData)? {
            if overview.isEmpty { return nil }
            return (title: "Overview", data: .textBased(cells: [(text: overview, detail: nil)]))
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
        
        private func cellData(forRecommended recommended: [Movie]) -> (title: String, data: SectionData) {
            var recommendedData: [(id: Int?, imagePath: String)] = []
            for item in recommended where item.id != nil && item.posterPath != nil {
                recommendedData.append((id: item.id, imagePath: item.posterPath!))
            }
            return (title: "Recommended Also", data: .imageBased(cellData: recommendedData))
        }
    }
}

