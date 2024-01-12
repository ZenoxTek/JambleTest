//
//  ProductCollectionViewCell.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {
    
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var size: UILabel!
    @IBOutlet private weak var bookmarkBtn: UIButton!
    @IBOutlet private weak var productImg: UIImageView!
    @IBOutlet private weak var productColor: UIView!
    
    func bind(from product: Product) {
        price.text = product.price(with: product.currency)
        price.textColor = .black
        title.text = product.title
        title.textColor = .black
        size.text = product.size
        size.textColor = .black
        bookmarkBtn.tintColor = .white
        if let heartImg = UIImage(named: "icon-heart")?.withTintColor(.white) {
            bookmarkBtn.setImage(heartImg, for: .normal)
        }
        productImg.isHidden = true
        productColor.backgroundColor = product.uiColor
    }
}
