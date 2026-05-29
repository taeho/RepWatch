//
//  SetupRestDurationView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// SetupRestDurationView.swift
// Step 5: 세트 사이 휴식 시간 선택 (1초 ~ 180초)
// 휴식 횟수 > 0 일 때만 진입

import SwiftUI

struct SetupRestDurationView: View {

    // MARK: - Properties

    @Bindable var viewModel: SetupViewModel
    @Binding var navigationPath: NavigationPath  // 추가

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {

            Text("휴식 시간")
                .font(.headline)

            Picker("휴식 시간", selection: $viewModel.config.restDuration) {
                ForEach(1...180, id: \.self) { n in
                    //Text("\(n) 초").tag(n)
                    Text("\(n) \(String(localized: "초"))").tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 80)

            NavigationLink("다음") {
                SetupSummaryView(viewModel: viewModel, navigationPath: $navigationPath)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .navigationTitle("휴식 시간")
        .navigationBarTitleDisplayMode(.inline)
    }
}
