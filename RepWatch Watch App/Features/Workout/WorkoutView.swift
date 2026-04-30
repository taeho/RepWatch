//
//  WorkoutView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// WorkoutView.swift
// 운동 실행 화면
// 현재 세트 / 횟수 표시 + 자동 카운팅 (MotionService 연결 전까지 탭으로 테스트)

import SwiftUI

struct WorkoutView: View {

    // MARK: - Properties

    @Bindable var viewModel: WorkoutViewModel

    // MARK: - Body

    var body: some View {
        ZStack {
            // 배경 탭 → 수동 렙 추가 (하체 모드 + 테스트용)
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    viewModel.addRep()
                }

            VStack(spacing: 6) {

                // 세트 진행 표시
                Text("\(viewModel.currentSet) / \(viewModel.config.totalSets) 세트")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // 현재 횟수 - 핵심 표시
                Text("\(viewModel.currentReps)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(repColor)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: viewModel.currentReps)

                // 목표 횟수
                Text("목표 \(viewModel.config.targetReps) 회")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                // 부위 표시
                Text(viewModel.config.bodyPart.displayName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)  // 운동 중 네비게이션 바 숨김
        .onAppear {
            viewModel.startWorkout()
        }
        // 휴식 화면으로 전환
        .navigationDestination(isPresented: $viewModel.goToRest) {
            RestView(
                viewModel: RestViewModel(
                    config: viewModel.config,
                    workoutViewModel: viewModel
                )
            )
        }
        // 완료 화면으로 전환
        .navigationDestination(isPresented: $viewModel.goToComplete) {
            CompleteView(
                config: viewModel.config,
                actualReps: viewModel.actualReps
            )
        }
    }

    // MARK: - 횟수에 따른 색상 변화
    // 목표에 가까울수록 초록색으로
    private var repColor: Color {
        let progress = Double(viewModel.currentReps) / Double(viewModel.config.targetReps)
        switch progress {
        case 0..<0.5:  return .white
        case 0.5..<0.8: return .yellow
        default:        return .green
        }
    }
}
