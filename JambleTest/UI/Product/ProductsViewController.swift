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
    
    // UI Elements
    
    let searchResultLabel = UILabel()
    let separator = UIView()
    let searchField = UISearchBar()
    let resetButton: UIButton = {
            let resetButton = UIButton()
            resetButton.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
            resetButton.setTitle("Reset", for: .normal)
            resetButton.setTitleColor(.white, for: .normal)
            resetButton.backgroundColor = .black
            resetButton.layer.cornerRadius = 16.0
            return resetButton
        }()

    let sortByButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Sort By"
        if let image = UIImage(named: "icon-menu-4-dots") {
            configuration.image = image.withTintColor(.white)
        }
        configuration.titlePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .black
        background.cornerRadius = 16.0
        configuration.background = background
        button.configuration = configuration
        button.setTitleColor(.white, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return button
    }()

    let filterButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Filter"
        if let image = UIImage(named: "icon-filter") {
            configuration.image = image.withTintColor(.white)
        }
        configuration.titlePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .black
        background.cornerRadius = 16.0
        configuration.background = background
        button.configuration = configuration
        button.setTitleColor(.white, for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        return button
    }()

    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var products: UICollectionView?
    
    // Combine Elements
    
    // Data Elements
    
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

        view.backgroundColor = .white
        configureTopScreen()
        configureSeparatorAndLabel()
        configureCollectionView()
        configureBottomScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadMockData()
        products?.reloadData()
        updateSearchResultLabel()
    }
    
    func configureTopScreen() {
        
        if let searchImage = UIImage(named: "icon-search")?.withTintColor(.gray) {
            searchField.setImage(searchImage, for: .search, state: .normal)
        }
        //searchField.placeholder = "Search"
        searchField.backgroundImage = UIImage()
        searchField.setTextField(color: .black.withAlphaComponent(0.1))
        searchField.set(textColor: .gray)
        searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        let topStackView = UIStackView(arrangedSubviews: [searchField, resetButton])
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.spacing = 8

        topStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(topStackView)

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.0)
        ])
    }

    func configureSeparatorAndLabel() {
        separator.backgroundColor = .lightGray.withAlphaComponent(0.2)
        searchResultLabel.textColor = .lightGray
        searchResultLabel.font = .systemFont(ofSize: 12.0)
        separator.translatesAutoresizingMaskIntoConstraints = false
        searchResultLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(separator)
        view.addSubview(searchResultLabel)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.0),
            separator.heightAnchor.constraint(equalToConstant: 1),

            searchResultLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            searchResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0)
        ])
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
          
        let productsCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        productsCV.backgroundColor = .red
        productsCV.collectionViewLayout = layout
        productsCV.backgroundColor = .white
        productsCV.registerNib(cellClass: ProductCollectionViewCell.self)
        productsCV.delegate = self
        productsCV.dataSource = self

        // Ajoutez des contraintes ou configurez le positionnement des éléments ici

        // Exemple de positionnement sous les éléments précédents
        productsCV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productsCV)
          
        NSLayoutConstraint.activate([
            productsCV.topAnchor.constraint(equalTo: searchResultLabel.bottomAnchor, constant: 16),
            productsCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            productsCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            productsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        products = productsCV
    }
    
    func configureBottomScreen() {
        view.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(sortByButton)
        buttonsStackView.addArrangedSubview(filterButton)

        // Configurer les contraintes
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    func updateSearchResultLabel() {
        searchResultLabel.text = (viewModel.productCount < 2)
            ? "Result: \(viewModel.productCount) item"
            : "Result: \(viewModel.productCount) items"
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    
}

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProductCollectionViewCell.self, forIndexPath: indexPath)
        if indexPath.item < viewModel.products.count {
            cell.bind(from: viewModel.products[indexPath.item])
        }
        return cell
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the size of each item based on your requirements
        let spacing: CGFloat = 2
        let itemWidth = (collectionView.bounds.width - spacing * 3) / 2 // Two items per row with spacing
        let itemHeight: CGFloat = 300 // Set the height as needed

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
