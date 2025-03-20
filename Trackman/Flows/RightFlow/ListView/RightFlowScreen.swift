//
//  RightFlowScreen.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import SwiftUI

struct RightFlowScreen: View {
    @Environment(FeatureStore.self) var featureStore
    var onOutput: TypeClosure<RightFlowScreenOutput>

    var body: some View {
        List {
            ForEach(featureStore.features, id: \.0) { key, value in
                Section(header: Text("\(key.rawValue.uppercased())")) {
                    ListView(items: value, onOutput: onOutput)
                }.font(Font.system(size: 12, weight: .light))
            }
        }.listStyle(.plain)
            .task {
                do {
                    try await featureStore.loadAllSections()
                } catch {
                    print("Error loading features: \(error)")
                }
            }
    }
}

struct ListView: View {
    var items: [FeatureListItemDTO]
    var onOutput: TypeClosure<RightFlowScreenOutput>

    var body: some View {
        ForEach(items) { item in
            ListItemView(item: item, onOutput: onOutput)
        }
    }
}


struct ListItemView: View {
    var item: FeatureListItemDTO
    var onOutput: TypeClosure<RightFlowScreenOutput>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(Font.system(size: 17, weight: .bold))
                Text("\(item.description ?? "No current description available.")")
                    .font(Font.system(size: 14, weight: .light))
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onOutput(.didSelectFeature(item))
        }
    }
}

#Preview {
    @Previewable @State var featureStore = FeatureStore(service: FeatureService())
    RightFlowScreen(onOutput: { _ in })
        .environment(featureStore)
}
