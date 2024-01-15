//
//  ProductsViewController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit
import Combine

// MARK: - ProductsViewController

final class ProductsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let searchResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray.withAlphaComponent(0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    let alertView = UIView()
    let searchField: UISearchBar = {
        let searchBar = UISearchBar()
        if let searchImage = UIImage(named: "icon-search")?.withTintColor(.gray) {
            searchBar.setImage(searchImage, for: .search, state: .normal)
        }
        searchBar.backgroundImage = UIImage()
        searchBar.setTextField(color: .black.withAlphaComponent(0.05))
        searchBar.set(textColor: .gray)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: String(localized: "Search"),
                                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return searchBar
    }()
    
    let resetButton: JambleActionButton = {
        let button = JambleActionButton()
        button.setCustomTitle(String(localized: "Reset"))
        return button
    }()
    
    let sortByButton: JambleActionButton = {
        let button = JambleActionButton()
        button.setCustomTitle(String(localized: "SortBy"))
        if let image = UIImage(named: "icon-menu-4-dots") {
            button.setCustomImage(with: image.withTintColor(.white), with: 4, isMirror: true)
        }
        return button
    }()
    
    let filterButton: JambleActionButton = {
        let button = JambleActionButton()
        button.setCustomTitle(String(localized: "Filter"))
        if let image = UIImage(named: "icon-filter") {
            button.setCustomImage(with: image.withTintColor(.white), with: 4, isMirror: true)
        }
        return button
    }()
        
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillProportionally
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
    
    
    // MARK: - Combine Elements
    
    private var cancellables = Set<AnyCancellable>()
    private let search = CurrentValueSubject<String, Never>("")
    private let filteringOrder = CurrentValueSubject<LogicalRulers, Never>(LogicalRulers())
    private let selection = PassthroughSubject<(Int, ProductsViewController), Never>()
    private let liked = PassthroughSubject<(Int, Bool), Never>()
    
    // MARK: - Data Elements
    
    private lazy var dataSource = makeDataSource()
    private let viewModel: ProductsViewModelType
    private var alertViewController: NoContentViewController?

    // MARK: - Initialization
    
    init(viewModel: ProductsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
}

// MARK: - View Lifecycle

extension ProductsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(to: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        search.send("")
        filteringOrder.send(filteringOrder.value)
    }
}

// MARK: - UI Configuration

extension ProductsViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureTopScreen()
        configureSeparatorAndLabel()
        configureCollectionView()
        configureBottomScreen()
        configureAlertView()
        hideKeyboardWhenTappedAround()
    }
    
    private func configureAlertView() {
        view.addSubview(alertView)
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupNoContentController() {
        alertViewController = NoContentViewController(nibName: nil, bundle: nil)
        add(alertViewController!, to: alertView)
    }
    
    private func hideNoContentController() {
        if let alertViewController {
            remove(alertViewController)
        }
    }
    
    private func configureTopScreen() {
        searchField.delegate = self
        searchField.searchTextField.delegate = self
        
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
            productsCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productsCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            self.filteringOrder.value.sorting = .none
        }
        
        let itemsOrdering = UIMenu(title: String(localized: "SortBy"), image: UIImage(named: "icon-menu-4-dots"),
                                   options: .displayInline, children: [
                                    UIAction(title: String(localized: "PriceAscMenu"), image: UIImage(systemName: "arrow.up"),
                                             handler: { _ in
                                                 self.filteringOrder.value.sorting = .asc
                                             }),
                                    UIAction(title: String(localized: "PriceDescMenu"), image: UIImage(systemName: "arrow.down"),
                                             handler: { _ in
                                                 self.filteringOrder.value.sorting = .desc
                                             }),
                                   ])
        
        let resetFiltering = UIAction(title: String(localized: "Reset"), attributes: .destructive) { _ in
            self.filteringOrder.value.filtering = (FilteringType.none, "")
        }
        
        let sizeMenuActions = ProductSize.allCases.filter { size in size != .unknown }.map { index -> UIAction in
            return UIAction(title: index.rawValue, handler: { _ in
                self.filteringOrder.value.filtering = (FilteringType.size, index.rawValue)
            })
        }
        
        let colorMenuActions = CustomColor.allCases.filter { color in color != .unknown }.map { index -> UIAction in
            return UIAction(title: index.description, handler: { _ in
                self.filteringOrder.value.filtering = (FilteringType.color, index.description)
            })
        }
        
        let favoritesActions = Bookmarked.allCases.filter { bookmark in bookmark != .unknown }.map { index -> UIAction in
            return UIAction(title: index.description, handler: { _ in
                self.filteringOrder.value.filtering = (FilteringType.bookmarked, index.description)
            })
        }
        
        let sizeMenu = UIMenu(title: String(localized: "Size"), options: .displayAsPalette, children: sizeMenuActions)
        
        let colorMenu = UIMenu(title: String(localized: "Color"), options: .displayAsPalette, children: colorMenuActions)
        
        let bookmarkedMenu = UIMenu(title: String(localized: "Bookmarked"), options: .displayInline, children: favoritesActions)
        
        let itemsFiltering = UIMenu(title: String(localized: "Filter"), image: UIImage(named: "icon-filter"),
                                    options: .displayInline, children: [
                                        sizeMenu,
                                        colorMenu,
                                        bookmarkedMenu
                                    ])
        sortByButton.linkedToMenuBehavior = true
        sortByButton.menu = UIMenu(title: "", children: [itemsOrdering, resetOrdering])
        sortByButton.showsMenuAsPrimaryAction = true
        filterButton.linkedToMenuBehavior = true
        filterButton.menu = UIMenu(title: "", children: [itemsFiltering, resetFiltering])
        filterButton.showsMenuAsPrimaryAction = true
    }
}

// MARK: - Data Binding

extension ProductsViewController {
    
    private func bind(to viewModel: ProductsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = ProductsViewModelInput(search: search.eraseToAnyPublisher(),
                                           filterOrdering: filteringOrder.eraseToAnyPublisher(),
                                           selection: selection.eraseToAnyPublisher(),
                                           liked: liked.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: ProductsState) {
        switch state {
        case .idle:
            /// TODO: Implement logic here if you have an idle state
            update(with: [], animate: true)
        case .loading:
            /// TODO Display a loadingView if you have some logics that take some times
            update(with: [], animate: true)
        case .noResults:
            alertView.isHidden = false
            productsCV.isHidden = true
            setupNoContentController()
            alertViewController?.showNoResults()
            update(with: [], animate: true)
        case .failure:
            alertView.isHidden = false
            productsCV.isHidden = true
            setupNoContentController()
            alertViewController?.showDataLoadingError()
            update(with: [], animate: true)
        case .success(let products):
            alertView.isHidden = true
            productsCV.isHidden = false
            hideNoContentController()
            update(with: products, animate: true)
        case .successLiked(let product):
            updateLiked(with: product)
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
    
    private func updateLiked(with product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections(Section.allCases)
            let items = self.dataSource.snapshot().itemIdentifiers.map { prod in
                if prod.id == product.id && prod.hasLiked != product.hasLiked {
                    return product
                }
                return prod
            }
            snapshot.appendItems(items)
            self.dataSource.applySnapshotUsingReloadData(snapshot)
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
        switch filteringOrder.value.filtering.0 {
        case .none:
            filterButton.setTitle(String(localized: "Filter"), for: .normal)
        case .color:
            filterButton.setTitle("\(String(localized: "Color")) - \(filteringOrder.value.filtering.1)", for: .normal)
        case .size:
            filterButton.setTitle("\(String(localized: "Size")) - \(filteringOrder.value.filtering.1)", for: .normal)
        case .bookmarked:
            if filteringOrder.value.filtering.1 == Bookmarked.bookmarked.description {
                filterButton.setTitle("\(String(localized: "Bookmarked")) - \(Bookmarked.bookmarked.displayedButton)", for: .normal)
            } else {
                filterButton.setTitle("\(String(localized: "Bookmarked")) - \(Bookmarked.unbookmarked.displayedButton)", for: .normal)
            }
        }
    }
    
    private func updateSortingButtonLabel() {
        switch filteringOrder.value.sorting {
        case .none:
            sortByButton.setTitle(String(localized: "SortBy"), for: .normal)
        case .asc:
            sortByButton.setTitle("\(String(localized: "Price")) Asc", for: .normal)
        case .desc:
            sortByButton.setTitle("\(String(localized: "Price")) Desc", for: .normal)
        }
    }
}

// MARK: - UI Actions

extension ProductsViewController {
    
    @objc func resetPressed() {
        searchField.text = ""
        //logicalRuler.searchString = ""
        search.value = ""
    }
    
    @objc func cellPressed(sender: UITapGestureRecognizer) {
        // Animate the cell before displaying cell detail
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            sender.view?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                sender.view?.transform = CGAffineTransform.identity
            }, completion: { _ in
                if let cell = sender.view as? ProductCollectionViewCell {
                    self.selection.send((cell.id, self))
                }
            })
        })
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ProductsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UISearchBarDelegate

extension ProductsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //logicalRuler.searchString = searchText
        //search.send(logicalRuler)
        search.value = searchText
    }
}

// MARK: - UICollectionViewDelegate

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
                cell.tag = product.id
                let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(self.cellPressed(sender:)))
                cell.addGestureRecognizer(tapGestureRecognizer)
                cell.bind(from: product, delegate: self)
                return cell
            }
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - ProductsCellDelegate

extension ProductsViewController: ProductsCellDelegate {
    
    func hasLiked(with productId: Int, hasLiked: Bool) {
        liked.send((productId, hasLiked))
    }
    
    func hasLikedOnDetail(with product: Product) {
        updateLiked(with: product)
    }
}
