//
//  CellGenerics.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 23.05.2021.
//

import UIKit

extension UICollectionView {
    /// Returns a reuseable cell object located by its identifier and casted to the appropriate type.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    ///   - indexPath: The index path specifying the location of the cell.
    ///                The data source receives this information when it is asked for the cell and should just pass it along.
    ///                This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
    /// - returns: An object of the appropriate cell type
    func dequeueReusableCell<C>(_ cellType: C.Type, for indexPath: IndexPath) -> C where C: UICollectionViewCell {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? C else {
            fatalError("Failed to find cell with identifier \"\(identifier)\" of type \"\(C.self)\"")
        }
        return cell
    }
    /// Registers the cell with the nib name and identifier same as the class name.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    func register<C>(_ cellType: C.Type) {
        let str = String(describing: C.self)
        self.register(UINib(nibName: str, bundle: nil), forCellWithReuseIdentifier: str)
    }
}

extension UITableView {
    /// Returns a reuseable cell object located by its identifier and casted to the appropriate type.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    ///   - indexPath: The index path specifying the location of the cell.
    ///                The data source receives this information when it is asked for the cell and should just pass it along.
    ///                This method uses the index path to perform additional configuration based on the cell’s position in the table view.
    /// - returns: An object of the appropriate cell type
    func dequeueReusableCell<C>(_ cellType: C.Type, for indexPath: IndexPath) -> C where C: UITableViewCell {
        let identifier = String(describing: cellType)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? C else {
            fatalError("Failed to find cell with identifier \"\(identifier)\" of type \"\(C.self)\"")
        }
        return cell
    }
    /// Registers the cell with the nib name and identifier same as the class name.
    ///
    /// - parameters:
    ///   - cellType:  The appropriate cell type
    func register<C>(_ cellType: C.Type) {
        let str = String(describing: C.self)
        self.register(UINib(nibName: str, bundle: nil), forCellReuseIdentifier: str)
    }
}
