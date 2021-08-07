//
//  GenericMediaCollectionViewCell.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var poster: UIImageView!
    var imagePath: String = "" {
        didSet {
            poster.load(fromUrl: ImagesMediator().getPosterUrl(for: imagePath))
        }
    }
}
