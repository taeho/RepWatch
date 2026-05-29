//
//  SetupSummaryView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// SetupSummaryView.swift
// Step 6: 설정 요약 확인 후 운동 시작
import SwiftUI

struct SetupSummaryView: View {

    @Bindable var viewModel: SetupViewModel
    @Binding var navigationPath: NavigationPath

    private var totalReps: Int {
        viewModel.config.totalSets * viewModel.config.targetReps
    }

    var body: some View {
        VStack(spacing: 6) {

            VStack(alignment: .leading, spacing: 4) {
                SummaryRow(label: "부위", value: viewModel.config.bodyPart.displayName)
                SummaryRow(
                    label: String(localized: "세트"),
                    value: "\(viewModel.config.totalSets) \(String(localized: "세트"))"
                )
                SummaryRow(
                    label: String(localized: "목표"),
                    value: "\(viewModel.config.targetReps) \(String(localized: "회"))"
                )
                SummaryRow(
                    label: String(localized: "휴식 횟수"),
                    value: viewModel.config.restCount == 0
                        ? String(localized: "없음")
                        : "\(viewModel.config.restCount)\(String(localized: "회")) / \(viewModel.config.restDuration)\(String(localized: "초"))"
                )
            }
            .padding(.bottom, 4)

            // NavigationLink → Button으로 교체
            // config 값을 path에 append → ContentView의 navigationDestination이 WorkoutView 생성
            Button("시작") {
                navigationPath.append(viewModel.config)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
        .navigationTitle("확인")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .font(.caption)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
