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

    // MARK: - Properties

    var viewModel: SetupViewModel
    @State private var navigateToWorkout = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 6) {

            // 설정 요약 표시
            VStack(alignment: .leading, spacing: 4) {
                SummaryRow(label: "부위", value: viewModel.config.bodyPart.displayName)
                SummaryRow(label: "세트", value: "\(viewModel.config.totalSets) 세트")
                SummaryRow(label: "횟수", value: "\(viewModel.config.targetReps) 회")
                SummaryRow(
                    label: "휴식",
                    value: viewModel.config.restCount == 0
                        ? "없음"
                        : "\(viewModel.config.restCount)회 / \(viewModel.config.restDuration)초"
                )
            }
            .padding(.bottom, 4)

            // 운동 시작 버튼
            NavigationLink("시작") {
                // Phase 3에서 WorkoutView로 연결 예정
                Text("운동 화면 준비 중")
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

// MARK: - SummaryRow (재사용 컴포넌트)

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
