//
//  SetupSetsView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// SetupSetsView.swift
// Step 2: 전체 세트 수 선택 (1 ~ 10)
// Digital Crown으로 스크롤 선택

import SwiftUI

struct SetupSetsView: View {

    // MARK: - Properties

    @Bindable var viewModel: SetupViewModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {

            Text("세트 수")
                .font(.headline)

            // Digital Crown 연동 피커
            Picker("세트 수", selection: $viewModel.config.totalSets) {
                ForEach(1...10, id: \.self) { n in
                    Text("\(n) 세트").tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 80)

            NavigationLink("다음") {
                SetupRepsView(viewModel: viewModel)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .navigationTitle("세트 수")
        .navigationBarTitleDisplayMode(.inline)
    }
}
