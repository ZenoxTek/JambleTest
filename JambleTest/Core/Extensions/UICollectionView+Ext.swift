//
//  UICollectionView+Ext.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - NibProvidable Protocol

/// Protocol for providing a nib name and corresponding UINib.
protocol NibProvidable {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibProvidable {
    static var nibName: String {
        return "\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

// MARK: - ReusableView Protocol

/// Protocol for providing a reuseIdentifier.
protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

// MARK: - UICollectionView Extension for Cell Registration and Dequeue

extension UICollectionView {

    /// Registers a UICollectionViewCell class for cell reuse.
    func registerClass<T: UICollectionViewCell>(cellClass: T.Type) where T: ReusableView {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    /// Registers a UICollectionViewCell class and its corresponding nib for cell reuse.
    func registerNib<T: UICollectionViewCell>(cellClass: T.Type) where T: NibProvidable & ReusableView {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    /// Dequeues a reusable UICollectionViewCell for a given indexPath.
    func dequeueReusableCell<T: UICollectionViewCell>(withClass cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with identifier: \(cellClass.reuseIdentifier) for index path: \(indexPath) is not \(T.self)")
        }
        return cell
    }
}

