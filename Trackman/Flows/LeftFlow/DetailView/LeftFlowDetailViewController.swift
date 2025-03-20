//
//  LeftFlowDetailViewController.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import UIKit
import Combine

class LeftFlowDetailViewController: UIViewController {

    private let viewModel: LeftFlowDetailViewModel

    private lazy var activityIndicationView = UIActivityIndicatorView(style: .medium)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.descriptionLabel, button])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var bindings: Set<AnyCancellable> = []
    
    init(viewModel: LeftFlowDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .white

        self.view.addSubview(imageView)
        self.view.addSubview(stackView)
        self.imageView.addSubview(activityIndicationView)
        self.setupConstraints()
        self.setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupBindings() {
        viewModel.$title
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateUI()
            })
            .store(in: &bindings)
        
        viewModel.$description
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateUI()
            })
            .store(in: &bindings)

        viewModel.$image
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateUI()
            })
            .store(in: &bindings)

        let stateValueHandler: (ViewModelState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.startLoading()
            case .ready:
                self?.finishLoading()
            case .error:
                self?.imageView.backgroundColor = .red
                self?.finishLoading()
            }
        }

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }

    private func setupConstraints() {
        self.activityIndicationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400),

            stackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicationView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 20),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func startLoading() {
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    private func finishLoading() {
        activityIndicationView.stopAnimating()
    }
    
    private func updateUI() {
        self.titleLabel.text = self.viewModel.title
        self.descriptionLabel.text = self.viewModel.description
        self.imageView.image = self.viewModel.image
    }
    
    @objc private func didTapBackButton() {
        self.viewModel.handleInput(.dismiss)
    }
}
