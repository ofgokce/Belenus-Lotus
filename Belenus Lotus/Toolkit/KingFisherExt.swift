//
//  KingFisherExt.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import Foundation
import Kingfisher

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @discardableResult
    func setImage(with urlString: String) -> DownloadTask? {
        let url = URL(string: urlString)
        return setImage(with: url)
    }
}
