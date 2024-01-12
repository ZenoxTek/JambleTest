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
    
    let productsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource = makeDataSource()

    // Combine Elements
    
    private var cancellables = Set<AnyCancellable>()
    private let search = PassthroughSubject<String, Never>()
    private let appear = PassthroughSubject<Void, Never>()
    
    // Data Elements
    
    private let viewModel: ProductsViewModelType
    
    init(viewModel: ProductsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
        /*viewModel.loadMockData()
        productsCV.reloadData()*/
    }
    
    private func configureUI() {
        view.backgroundColor = .white

        configureTopScreen()
        configureSeparatorAndLabel()
        configureCollectionView()
        configureBottomScreen()
    }
    
    private func configureTopScreen() {
        
        if let searchImage = UIImage(named: "icon-search")?.withTintColor(.gray) {
            searchField.setImage(searchImage, for: .search, state: .normal)
        }
        searchField.backgroundImage = UIImage()
        searchField.setTextField(color: .black.withAlphaComponent(0.1))
        searchField.set(textColor: .gray)
        searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchField.delegate = self
        
        resetButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)

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

    private func configureSeparatorAndLabel() {
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

    private func configureCollectionView() {
        view.addSubview(productsCV)
          
        productsCV.registerNib(cellClass: ProductCollectionViewCell.self)
        productsCV.dataSource = dataSource
        productsCV.delegate = self
        
        NSLayoutConstraint.activate([
            productsCV.topAnchor.constraint(equalTo: searchResultLabel.bottomAnchor, constant: 16),
            productsCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            productsCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            productsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureBottomScreen() {
        view.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(sortByButton)
        buttonsStackView.addArrangedSubview(filterButton)

        // Configurer les contraintes
        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bind(to viewModel: ProductsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = ProductsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                           search: search.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    /// TODO: Implement a view When no data is found. Implement a loading indicator when executing an action that may change the list content
    private func render(_ state: ProductsState) {
        switch state {
        case .idle(let products):
            //alertViewController.view.isHidden = false
            //alertViewController.showStartSearch()
            //loadingView.isHidden = true
            update(with: products, animate: true)
        case .loading:
            //alertViewController.view.isHidden = true
            //loadingView.isHidden = false
            update(with: [], animate: true)
        case .noResults:
            //alertViewController.view.isHidden = false
            //alertViewController.showNoResults()
            //loadingView.isHidden = true
            update(with: [], animate: true)
        case .failure:
            //alertViewController.view.isHidden = false
            //alertViewController.showDataLoadingError()
            //loadingView.isHidden = true
            update(with: [], animate: true)
        case .success(let products):
            //alertViewController.view.isHidden = true
            //loadingView.isHidden = true
            update(with: products, animate: true)
        }
    }
    
    private func update(with products: [Product], animate: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.updateSearchResultLabel(with: products.count)
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(products, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
    
    private func updateSearchResultLabel(with newCount: Int) {
        searchResultLabel.text = (newCount < 2)
            ? "Result: \(newCount) item"
            : "Result: \(newCount) items"
    }
}

extension ProductsViewController {
    
    @objc func resetPressed() {
        searchField.text = ""
        appear.send(())
    }
}

extension ProductsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            appear.send(())
        } else {
            search.send(searchText)
        }
    }
}

extension ProductsViewController: UICollectionViewDelegate {
    enum Section: CaseIterable {
        case products
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Product> {
        return UICollectionViewDiffableDataSource(
            collectionView: productsCV,
            cellProvider: {  collectionView, indexPath, product in
                let cell = collectionView.dequeueReusableCell(withClass: ProductCollectionViewCell.self,
                                                              forIndexPath: indexPath)
                cell.bind(from: product)
                return cell
            }
        )
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
