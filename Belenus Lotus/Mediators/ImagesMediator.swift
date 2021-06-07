//
//  ImagesMediator.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 25.05.2021.
//

import Foundation

struct ImagesMediator {
    enum ImageSize: Int { case s = 0, m, l, xl}
    
    func getPosterUrl(for media: AnyMedia, withSize size: ImageSize = .l) -> URL? {
        guard let path = media.posterPath else { return nil }
        return getPosterUrl(for: path)
    }
    
    func getBackdropUrl(for media: AnyMedia, withSize size: ImageSize = .l) -> URL? {
        guard let path = media.backdropPath else { return nil }
        return getBackdropUrl(for: path)
    }
    
    func getPosterUrl(for path: String, withSize size: ImageSize = .l) -> URL? {
        return URL(string: TMDBManager.shared.request(.poster(size: size.rawValue, path: path)))
    }
    
    func getBackdropUrl(for path: String, withSize size: ImageSize = .l) -> URL? {
        return URL(string: TMDBManager.shared.request(.backdrop(size: size.rawValue, path: path)))
    }
}
