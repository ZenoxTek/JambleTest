//
//  DetailProductViewController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import UIKit
import Combine

// MARK: - ProductDetailsViewController

final class ProductDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: JambleActionButton = {
        let button = JambleActionButton()
        button.setCustomTitle(String(localized: "AddToBookmarks"))
        if let image = UIImage(named: "icon-heart") {
            button.setCustomImage(with: image.withTintColor(.white), with: 4, isMirror: true)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Combine Elements
    
    private var cancellables = Set<AnyCancellable>()
    private let appear = PassthroughSubject<Void, Never>()

    // MARK: - Data Elements
    
    private let viewModel: ProductDetailsViewModelType
    private var alertViewController: NoContentViewController?
    private var productId = -1
    private var hasLiked = false

    // MARK: - Initialization
    
    init(viewModel: ProductDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
}

// MARK: - View Lifecycle

extension ProductDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        layoutViews()
        setupAction()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialCall()
    }
}

// MARK: - UI Configuration

extension ProductDetailsViewController {
    
    private func setupNoContentController() {
        favoriteButton.isEnabled = false
        alertViewController = NoContentViewController(nibName: nil, bundle: nil)
        add(alertViewController!, to: view)
    }
    
    private func hideNoContentController() {
        favoriteButton.isEnabled = true
        if let alertViewController {
            remove(alertViewController)
        }
    }
    
    private func setupViews() {
        view.addSubview(productColorView)
        view.addSubview(productNameLabel)
        
        
        view.addSubview(favoriteButton)
        view.addSubview(closeButton)
        favoriteButton.isHidden = true
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            productColorView.topAnchor.constraint(equalTo: view.topAnchor),
            productColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productColorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
            
        let labelsStackView = UIStackView(arrangedSubviews: [priceLabel, sizeLabel])
        labelsStackView.axis = .horizontal
        labelsStackView.spacing = 8
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelsStackView)
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: productColorView.bottomAnchor, constant: 32),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.bottomAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: -200),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.heightAnchor.constraint(equalToConstant: 64),
            sizeLabel.heightAnchor.constraint(equalToConstant: 64)
        ])

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupAction() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Data Binding

extension ProductDetailsViewController {
    
    private func initialCall() {
        view.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appear.send(())
        }
    }
    
    private func bind(to viewModel: ProductDetailsViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = ProductDetailsViewModelInput(appear: appear.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    
    private func render(_ state: ProductDetailsState) {
        view.hideActivityIndicator()
        switch state {
        case .nothing:
            return
        case .loading:
            /// TODO Display a loadingView if you have some logics that take some times
            //update(with: [], animate: true)
            return
        case .failure:
            setupNoContentController()
            alertViewController?.showDataLoadingError()
            return
        case .success(let product):
            hideNoContentController()
            update(with: product)
        case .successLiked(let product):
            updateLiked(with: product)
        }
    }
    
    private func update(with product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            updateLayout(with: product)
        }
    }
    
    private func updateLayout(with product: Product) {
        productId = product.id
        productImageView.isHidden = true
        productColorView.backgroundColor = product.uiColor
        productNameLabel.text = product.title
        priceLabel.text = product.price(with: product.currency)
        sizeLabel.text = product.size
        favoriteButton.isHidden = false
        self.hasLiked = product.hasLiked
        favoriteButton.setCustomBackgroundColor(with: (product.hasLiked) ? .red : .black)
    }
    
    private func updateLiked(with product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            favoriteButton.setCustomBackgroundColor(with: (product.hasLiked) ? .red : .black)
            self.hasLiked = product.hasLiked
        }
    }
}

// MARK: - UI Actions

extension ProductDetailsViewController {
    
    // Action when the favorite button is tapped
    @objc private func favoriteButtonTapped() {
        if productId > 0 {
            viewModel.publishLikeData(with: productId, action: !self.hasLiked)
        }
    }

    // Action when the close button is tapped
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
