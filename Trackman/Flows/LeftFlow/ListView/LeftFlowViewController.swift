//
//  LeftFlowViewController.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import UIKit
import Combine

class LeftFlowViewController: UIViewController {
    private let viewModel: LeftFlowViewModel
    private var bindings = Set<AnyCancellable>()

    private lazy var dataSource: UITableViewDiffableDataSource<ListCategory, FeatureListItemDTO> = UITableViewDiffableDataSource<ListCategory, FeatureListItemDTO>(tableView: tableView) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = item.name
        content.textProperties.font = .systemFont(ofSize: 17, weight: .bold)
        content.secondaryText = item.description
        content.secondaryTextProperties.font = .systemFont(ofSize: 14, weight: .light)

        cell.contentConfiguration = content

        return cell
    }

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var activityIndicationView = UIActivityIndicatorView(style: .medium)

    init (viewModel: LeftFlowViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .white

        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicationView)

        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.setupBindings()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupConstraints() {
        self.activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 20),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupBindings() {
        viewModel.$sections
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateSections()
            })
            .store(in: &bindings)

        let stateValueHandler: (ViewModelState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.startLoading()
            case .ready:
                self?.finishLoading()
            case .error:
                self?.finishLoading()
            }
        }

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }
    
    private func startLoading() {
        tableView.isUserInteractionEnabled = false
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    private func finishLoading() {
        tableView.isUserInteractionEnabled = true
        activityIndicationView.stopAnimating()
    }
    
    private func updateSections() {
        var snapshot = NSDiffableDataSourceSnapshot<ListCategory, FeatureListItemDTO>()
        
        for section in viewModel.sections {
            snapshot.appendSections([section.0])
            snapshot.appendItems(section.1, toSection: section.0)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension LeftFlowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleInput(.showFeatureDetail(dataSource.snapshot().itemIdentifiers[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewHeader = UITableViewHeaderFooterView()
        
        var content = UIListContentConfiguration.header()
        content.text = "\(dataSource.snapshot().sectionIdentifiers[section].rawValue)"
        content.textProperties.font = .systemFont(ofSize: 12, weight: .light)

        tableViewHeader.contentConfiguration = content

        return tableViewHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
