//
//  ProductCollectionViewCell.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, NibProvidable, ReusableView {
    
    @IBOutlet private weak var title: UILabel!
        
    func bind(from product: Product) {
        title.text = product.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
