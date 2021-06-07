//
//  GenericMediaCollectionViewCell.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var poster: UIImageView!
    var imagePath: String = "" {
        didSet {
            poster.kf.setImage(with: ImagesMediator().getPosterUrl(for: imagePath))
        }
    }
}
