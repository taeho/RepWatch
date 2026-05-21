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
    let onGoHome: () -> Void          // 추가 (navigationPath, dismiss 전부 제거)

    @Environment(\.modelContext) private var modelContext
    @State private var isSaved: Bool = false

    private var totalReps: Int {
        actualReps.reduce(0, +)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.green)

                Text("완료!")
                    .font(.headline)
                    .fontWeight(.bold)

                Divider()

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
                                .foregroundStyle(
                                    reps >= config.targetReps ? .green : .yellow
                                )
                        }
                    }
                }

                Divider()

                HStack {
                    Text("총 횟수")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(totalReps) 회")
                        .font(.caption)
                        .fontWeight(.bold)
                }

                if isSaved {
                    Label("기록 저장됨", systemImage: "checkmark")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // 클로저 호출로 교체
                Button {
                    onGoHome()
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
