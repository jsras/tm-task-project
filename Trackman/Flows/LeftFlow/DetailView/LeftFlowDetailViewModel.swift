//
//  LeftFlowDetailViewModel.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Combine
import Foundation
import UIKit

enum LeftFlowDetailViewModelInput {
    case dismiss
}

enum LeftFlowDetailViewModelOutput {
    case dismiss, error(Error)
}

final class LeftFlowDetailViewModel {
    @Published var title: String
    @Published var description: String
    @Published var image: UIImage?
    @Published private(set) var state: ViewModelState = .loading

    private let featureListItemDTO: FeatureListItemDTO
    private let onOutput: TypeClosure<LeftFlowDetailViewModelOutput>
    
    init(detailFeature: FeatureListItemDTO, onOutput: @escaping TypeClosure<LeftFlowDetailViewModelOutput>) {
        self.featureListItemDTO = detailFeature
        self.onOutput = onOutput
        
        self.title = detailFeature.name
        self.description = detailFeature.description ?? "No current description available."

        loadImage(url: detailFeature.imageUrl)
    }
    
    func loadImage(url: String) {
        self.state = .loading
        
        let service = NetworkService<FeatureAPI>()
        Task {
            do {
                try await service.getData(fromURL: url).map { data in
                    image = UIImage(data: data)
                    self.state = .ready
                }
            }
            catch {
                self.state = .error(error)
                onOutput(.error(error))
            }
        }
    }
    
    func handleInput(_ input: LeftFlowDetailViewModelInput) {
        switch input {
        case .dismiss:
            onOutput(.dismiss)
        }
    }
}
