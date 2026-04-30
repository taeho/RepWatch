//
//  SetupView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//
// SetupView.swift
// Step 1: 운동 부위 선택 (상체 / 하체)

import SwiftUI

struct SetupView: View {

    // MARK: - Properties

    @State private var viewModel = SetupViewModel()

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {

            Text("운동 부위")
                .font(.headline)

            // 상체 버튼
            NavigationLink {
                SetupSetsView(viewModel: viewModel)
            } label: {
                Label("상체", systemImage: "figure.strengthtraining.traditional")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.config.bodyPart = .upper
            })

            // 하체 버튼
            NavigationLink {
                SetupSetsView(viewModel: viewModel)
            } label: {
                Label("하체", systemImage: "figure.leg.press")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.config.bodyPart = .lower
            })
        }
        .padding(.horizontal, 4)
        .navigationTitle("RepWatch")
        .navigationBarTitleDisplayMode(.inline)
    }
}
