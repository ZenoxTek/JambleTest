//
//  NoContentViewController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import UIKit

final class NoContentViewController: UIViewController {

    private var stackView: UIStackView!

    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()

    private var errorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private var errorDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureStackView()
    }

    func showNoResults() {
        render(viewModel: NoContentViewModel.noResults)
    }

    func showDataLoadingError() {
        render(viewModel: NoContentViewModel.dataLoadingError)
    }

    private func render(viewModel: NoContentViewModel) {
        errorTitle.text = viewModel.title
        errorDescription.text = viewModel.description
        iconView.image = viewModel.image
    }

    private func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [iconView, errorTitle, errorDescription])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
