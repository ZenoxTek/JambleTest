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
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = String(localized: "Reset")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = .black
        background.cornerRadius = 16.0
        configuration.background = background
        button.configuration = configuration
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    let sortByButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = String(localized: "SortBy")
        if let image = UIImage(named: "icon-menu-4-dots") {
            configuration.image = image.withTintColor(.white)
        }
        configuration.imagePadding = 4
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
        configuration.title = String(localized: "Filter")
        if let image = UIImage(named: "icon-filter") {
            configuration.image = image.withTintColor(.white)
        }
        configuration.imagePadding = 4
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
    private let search = PassthroughSubject<LogicalRulers, Never>()
    private var logicalRuler = LogicalRulers()
    
    //private let appear = PassthroughSubject<Void, Never>()
    //private let filterOpen = PassthroughSubject<Void, Never>()
    //private let sortBy = PassthroughSubject<(Bool, String), Never>()
    
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
        search.send(logicalRuler)
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
        searchField.searchTextField.attributedPlaceholder = NSAttributedString(string: String(localized: "Search"),
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
        configureMenuOnActionButtons()
    }
    
    private func configureMenuOnActionButtons() {
        
        let resetOrdering = UIAction(title: String(localized: "Reset"), attributes: .destructive) { _ in
            self.logicalRuler.sorting = .none
            self.search.send(self.logicalRuler)
        }
        
        let itemsOrdering = UIMenu(title: String(localized: "SortBy"), image: UIImage(named: "icon-menu-4-dots"),
                                   options: .displayInline, children: [
            UIAction(title: String(localized: "PriceAscMenu"), image: UIImage(systemName: "arrow.up"),
                     handler: { _ in
                         self.logicalRuler.sorting = .asc
                         self.search.send(self.logicalRuler)
                     }),
            UIAction(title: String(localized: "PriceDescMenu"), image: UIImage(systemName: "arrow.down"),
                     handler: { _ in
                         self.logicalRuler.sorting = .desc
                         self.search.send(self.logicalRuler)
                     }),
        ])
        
        let resetFiltering = UIAction(title: String(localized: "Reset"), attributes: .destructive) { _ in
            self.logicalRuler.filtering = (FilteringType.none, "")
            self.search.send(self.logicalRuler)
        }
        
        let sizeMenuActions = ProductSize.allCases.filter { size in size != .unknown }.map { index -> UIAction in
            return UIAction(title: index.rawValue, handler: { _ in
                self.logicalRuler.filtering = (FilteringType.size, index.rawValue)
                self.search.send(self.logicalRuler)
            })
        }
        
        let colorMenuActions = CustomColor.allCases.filter { color in color != .unknown }.map { index -> UIAction in
            return UIAction(title: index.description, handler: { _ in
                self.logicalRuler.filtering = (FilteringType.color, index.description)
                self.search.send(self.logicalRuler)
            })
        }
        
        let sizeMenu = UIMenu(title: String(localized: "Size"), options: .displayAsPalette, children: sizeMenuActions)
        
        let colorMenu = UIMenu(title: String(localized: "Color"), options: .displayAsPalette, children: colorMenuActions)
        
        let itemsFiltering = UIMenu(title: String(localized: "Filter"), image: UIImage(named: "icon-filter"),
                                    options: .displayInline, children: [
                                        sizeMenu,
                                        colorMenu
                                    ])
        
        sortByButton.menu = UIMenu(title: "", children: [itemsOrdering, resetOrdering])
        sortByButton.showsMenuAsPrimaryAction = true
        filterButton.menu = UIMenu(title: "", children: [itemsFiltering, resetFiltering])
        filterButton.showsMenuAsPrimaryAction = true
    }
    
    private func bind(to viewModel: ProductsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = ProductsViewModelInput(search: search.eraseToAnyPublisher())

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
            updateLayout(with: products.count)
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(products, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
    
    private func updateLayout(with productItemsNb: Int) {
        updateSearchResultLabel(with: productItemsNb)
        updateFilterButtonLabel()
        updateSortingButtonLabel()
    }
        
    private func updateSearchResultLabel(with newCount: Int) {
        searchResultLabel.text = String(localized: "Result: \(newCount) items")
    }
    
    private func updateFilterButtonLabel() {
        switch logicalRuler.filtering.0 {
        case .none:
            filterButton.setTitle(String(localized: "Filter"), for: .normal)
        case .color:
            filterButton.setTitle("\(String(localized: "Color")) - \(logicalRuler.filtering.1)", for: .normal)
        case .size:
            filterButton.setTitle("\(String(localized: "Size")) - \(logicalRuler.filtering.1)", for: .normal)
        }
    }
    
    private func updateSortingButtonLabel() {
        switch logicalRuler.sorting {
        case .none:
            sortByButton.setTitle(String(localized: "SortBy"), for: .normal)
        case .asc:
            sortByButton.setTitle("\(String(localized: "Price")) Asc", for: .normal)
        case .desc:
            sortByButton.setTitle("\(String(localized: "Price")) Desc", for: .normal)
        }
    }
}

extension ProductsViewController {
    
    @objc func resetPressed() {
        searchField.text = ""
        logicalRuler.searchString = ""
        search.send(logicalRuler)
    }
}

extension ProductsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        logicalRuler.searchString = searchText
        search.send(logicalRuler)
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
