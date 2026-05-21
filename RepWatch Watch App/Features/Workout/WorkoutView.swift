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
    // navigationPath 파라미터 제거 (더 이상 필요 없음)

    @Bindable var viewModel: WorkoutViewModel
    @Environment(AppState.self) private var appState

    // MARK: - Body

    var body: some View {
        ZStack {
            // 메인 운동 화면
            workoutContent

            // CompleteView 오버레이 (navigationDestination 대신)
            if viewModel.goToComplete {
                CompleteView(
                    config: viewModel.config,
                    actualReps: viewModel.actualReps,
                    onGoHome: {
                        appState.shouldResetToRoot = true  // path 초기화 → 전부 제거
                    }
                )
                .background(Color.black)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: viewModel.goToComplete)
            }
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.startWorkout()
        }
        .navigationDestination(isPresented: $viewModel.goToRest) {
            RestView(
                viewModel: RestViewModel(
                    config: viewModel.config,
                    workoutViewModel: viewModel
                )
            )
        }
    }

    // MARK: - 운동 메인 콘텐츠 분리

    private var workoutContent: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    viewModel.addRep()
                }

            VStack(spacing: 6) {
                Text("\(viewModel.currentSet) / \(viewModel.config.totalSets) 세트")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(viewModel.currentReps)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(repColor)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: viewModel.currentReps)

                Text("목표 \(viewModel.config.targetReps) 회")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(viewModel.config.bodyPart.displayName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

                Text(String(format: "%.2f g", viewModel.currentMagnitude))
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
                    .monospacedDigit()
            }
        }
    }

    private var repColor: Color {
        let progress = Double(viewModel.currentReps) / Double(viewModel.config.targetReps)
        switch progress {
        case 0..<0.5:   return .white
        case 0.5..<0.8: return .yellow
        default:         return .green
        }
    }
}
