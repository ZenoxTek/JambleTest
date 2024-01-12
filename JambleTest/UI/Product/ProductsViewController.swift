//
//  ProductsViewController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit
import Combine

final class ProductsViewController: UIViewController {
    
    @IBOutlet private weak var productsCV: UICollectionView!
    
    var viewModel: ProductsViewModel
    
    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ProductsViewModel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        /*productsCV.registerNib(cellClass: ProductCollectionViewCell.self)
        productsCV.dataSource = self
        productsCV.delegate = self*/
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    
}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//extension ProductsViewController: UICollectionViewFlowLayout { }
