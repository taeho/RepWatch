//
//  SetupRestCountView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// SetupRestCountView.swift
// Step 4: 휴식 횟수 선택
// 0 = 휴식 없음, 최대 = 세트수 - 1

import SwiftUI

struct SetupRestCountView: View {

    // MARK: - Properties

    @Bindable var viewModel: SetupViewModel

    // 최대 휴식 횟수 = 세트 수 - 1
    private var maxRestCount: Int {
        viewModel.config.totalSets - 1
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {

            Text("휴식 횟수")
                .font(.headline)

            // 0이면 "없음" 으로 표시
            Picker("휴식 횟수", selection: $viewModel.config.restCount) {
                Text("없음").tag(0)
                ForEach(1...max(1, maxRestCount), id: \.self) { n in
                    Text("\(n) 회").tag(n)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 80)
            // 세트 수 변경 시 휴식 횟수 범위 초과 방지
            .onChange(of: viewModel.config.totalSets) {
                if viewModel.config.restCount > maxRestCount {
                    viewModel.config.restCount = maxRestCount
                }
            }

            // 휴식 있으면 → 휴식시간 설정, 없으면 → 바로 요약
            NavigationLink("다음") {
                if viewModel.config.restCount > 0 {
                    SetupRestDurationView(viewModel: viewModel)
                } else {
                    SetupSummaryView(viewModel: viewModel)
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .navigationTitle("휴식 횟수")
        .navigationBarTitleDisplayMode(.inline)
    }
}
