//
//  CollectionTableViewCell.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 29.05.2021.
//

import UIKit

class ImageCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellData: [(id: Int?, imagePath: String)] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var cellSize: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectionCallback: (_ withId: Int) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ImageCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ImageCollectionViewCell.self, for: indexPath)
        cell.imagePath = cellData[indexPath.row].imagePath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = cellData[indexPath.row].id {
            selectionCallback(id)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
