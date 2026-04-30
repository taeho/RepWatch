//
//  SetupRepsView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// SetupRepsView.swift
// Step 3: 세트당 목표 횟수 선택 (1 ~ 30)

import SwiftUI

struct SetupRepsView: View {

    // MARK: - Properties

    @Bindable var viewModel: SetupViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {

            Text("세트당 횟수")
                .font(.headline)

            Picker("횟수", selection: $viewModel.config.targetReps) {
                ForEach(1...30, id: \.self) { n in
                    Text("\(n) 회").tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 80)

            NavigationLink("다음") {
                SetupRestCountView(viewModel: viewModel)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .navigationTitle("횟수")
        .navigationBarTitleDisplayMode(.inline)
    }
}
