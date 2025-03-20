//
//  RightFlowDetailScreen.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 20/03/2025.
//

import SwiftUI
import Combine

struct RightFlowDetailScreen: View {
    @State var viewState: RightFlowDetailViewState
    let onOutput: TypeClosure<RightFlowScreenOutput>
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                AsyncImage(url: viewState.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .opacity(0.5)
                        .tint(Color.gray)
                }
                .frame(height: 400)
                Spacer()
                    .frame(height: 16.0)
                VStack(alignment: .leading) {
                    Text(viewState.title)
                        .font(Font.system(size: 17, weight: .bold))
                    Spacer()
                        .frame(height: 8.0)
                    Text(viewState.subtitle)
                        .font(Font.system(size: 14, weight: .light))
                }
            }
            Spacer()
                .frame(height: 8.0)
            HStack {
                Button(action: {
                    onOutput(.dismiss)
                }, label: {
                    Text("Go back")
                })
            }
        }.background(Color.white)
    }
}

#Preview {
    let feature = FeatureListItemDTO(id: "ID",
                                     name: "Name",
                                     description: "Description")
    let viewState = RightFlowDetailViewState(feature: feature)
    RightFlowDetailScreen(viewState: viewState, onOutput: { _ in })
}
