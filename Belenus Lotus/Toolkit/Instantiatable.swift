//
//  Instantiatable.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 24.05.2021.
//

import UIKit

protocol Instantiatable {

    static func instantiate() -> Self
}

public protocol NibLoadable: class {

    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {

    /// By default, use the nib which have the same name as the name of class
    static var nib: UINib {

        return UINib(nibName: String(describing: self), bundle: nil)
    }

    /// Returns a UIView object instantiated from nib
    ///
    /// - Returns: A `NibLoadable`, `UIView` instance
    static func instanceFromNib() -> Self {

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }

        return view
    }
}

extension Instantiatable where Self: UIViewController {

    static func instantiate() -> Self {
        return Self(nibName: "\(self)", bundle: bundle)
    }

    // MARK: - Private
    private static var bundle: Bundle {
        return Bundle(for: self)
    }

    private static func load<T>(type: T.Type, from storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension Instantiatable where Self: UIView {

    static func instantiate() -> Self {
        return load(type: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }

    // MARK: - Private
    private static var bundle: Bundle {
        return Bundle(for: self)
    }

    private static var nibName: String {
        return String(describing: self)
    }

    private static func load<T>(type: T.Type) -> T {
        let nibContents = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        return nibContents?.first { $0 is T } as! T
    }
}
