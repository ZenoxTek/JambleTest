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
    @IBOutlet private weak var bookmarkBtn: RoundedCornerButton!
    @IBOutlet private weak var productImg: UIImageView!
    @IBOutlet private weak var productColor: UIView!
    
    private var isBookmarked = false
    private var numberBookmark = 0
    
    func bind(from product: Product) {
        price.text = product.price(with: product.currency)
        price.textColor = .black
        title.text = product.title
        title.textColor = .black
        size.text = product.size
        size.textColor = .black
        productImg.isHidden = true
        productColor.backgroundColor = product.uiColor
        setupBookmarkButton()
    }
    
    private func setupBookmarkButton() {
        bookmarkBtn.tintColor = .white
        if let heartImg = UIImage(named: "icon-heart")?.withTintColor(.white) {
            bookmarkBtn.setImage(heartImg, for: .normal)
        }
        bookmarkBtn.setTitle("\(numberBookmark)", for: .normal)
        bookmarkBtn.addTarget(self, action: #selector(bookmarkPressed), for: .touchDown)
        bookmarkBtn.addTarget(self, action: #selector(bookmarkReleased), for: .touchUpOutside)
        bookmarkBtn.addTarget(self, action: #selector(bookmarkReleased), for: .touchUpInside)
    }
    
    @objc func bookmarkPressed() {
        isBookmarked.toggle()
        numberBookmark += (isBookmarked) ? 1 : -1
        
        UIView.animate(withDuration: 0.1) {
            // Animate the button to a smaller size
            self.bookmarkBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc func bookmarkReleased() {
        // Animate the button to a larger size
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
           
            self.bookmarkBtn.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
           
            // Animate the button back to its normal size
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.bookmarkBtn.transform = CGAffineTransform.identity
            }, completion: { _ in
               
                // Update the button appearance
                if let heartImg = UIImage(named: "icon-heart")?.withTintColor((self.isBookmarked) ? .red : .white) {
                    self.bookmarkBtn.setImage(heartImg, for: .normal)
                }
                self.bookmarkBtn.setTitle("\(self.numberBookmark)", for: .normal)
            })
        })
    }
}
