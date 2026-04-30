//
//  RestView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// RestView.swift
// 휴식 타이머 화면
// 원형 프로그레스 + 남은 시간 + Skip 버튼

import SwiftUI

struct RestView: View {

    // MARK: - Properties

    @Bindable var viewModel: RestViewModel

    // 타이머 진행률 (1.0 → 0.0)
    private var progress: Double {
        Double(viewModel.remainingSeconds) / Double(viewModel.config.restDuration)
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {

            // 원형 타이머
            ZStack {
                // 배경 원
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 6)

                // 진행 원 (시간 줄어들수록 줄어듦)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(timerColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: progress)

                // 남은 시간 텍스트
                VStack(spacing: 2) {
                    Text("\(viewModel.remainingSeconds)")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(timerColor)
                        .contentTransition(.numericText(countsDown: true))
                        .animation(.snappy, value: viewModel.remainingSeconds)

                    Text("초")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 100, height: 100)

            // 휴식 라벨
            Text("휴식 중")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Skip 버튼
            Button {
                viewModel.skip()
            } label: {
                Label("건너뛰기", systemImage: "forward.fill")
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
        .padding(.horizontal, 4)
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.startRest()
        }
    }

    // MARK: - 남은 시간에 따른 색상
    // 시간 줄어들수록 빨간색으로 변화
    private var timerColor: Color {
        switch progress {
        case 0.5...: return .green
        case 0.25..<0.5: return .yellow
        default: return .red
        }
    }
}
