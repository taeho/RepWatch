//
//  CompleteView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// CompleteView.swift
// 운동 완료 화면
// 세트별 기록 요약 + SwiftData 저장

import SwiftUI
import SwiftData

struct CompleteView: View {

    // MARK: - Properties

    let config: WorkoutConfig
    let actualReps: [Int]

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // 저장 완료 여부 (중복 저장 방지)
    @State private var isSaved: Bool = false
    @Binding var navigationPath: NavigationPath  // 추가

    // MARK: - 총 완료 횟수
    private var totalReps: Int {
        actualReps.reduce(0, +)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {

                // 완료 아이콘
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.green)

                Text("완료!")
                    .font(.headline)
                    .fontWeight(.bold)

                Divider()

                // 세트별 결과
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(actualReps.enumerated()), id: \.offset) { index, reps in
                        HStack {
                            Text("\(index + 1) 세트")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(reps) 회")
                                .font(.caption)
                                .fontWeight(.medium)
                                // 목표 달성 여부 색상
                                .foregroundStyle(
                                    reps >= config.targetReps ? .green : .yellow
                                )
                        }
                    }
                }

                Divider()

                // 총합
                HStack {
                    Text("총 횟수")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(totalReps) 회")
                        .font(.caption)
                        .fontWeight(.bold)
                }

                // 저장 상태 표시
                if isSaved {
                    Label("기록 저장됨", systemImage: "checkmark")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // 홈으로 버튼
                Button {
                    navigationPath = NavigationPath()  // 스택 전체 초기화 → 루트로 복귀
                } label: {
                    Text("홈으로")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .padding(.top, 4)
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            saveRecord()
            HapticService.workoutComplete()
        }
    }

    // MARK: - 저장 (중복 방지)

    private func saveRecord() {
        guard !isSaved else { return }
        WorkoutRepository.save(
            context: modelContext,
            config: config,
            actualReps: actualReps
        )
        isSaved = true
    }
}
