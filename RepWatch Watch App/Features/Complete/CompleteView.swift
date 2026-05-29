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

    let config: WorkoutConfig
    let actualReps: [Int]
    let onGoHome: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var isSaved: Bool = false

    private var totalReps: Int {
        actualReps.reduce(0, +)
    }

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
                            // ✅ 수정
                            Text("\(index + 1) \(String(localized: "세트"))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            // ✅ 수정
                            Text("\(reps) \(String(localized: "회"))")
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
                    // ✅ 수정
                    Text("\(totalReps) \(String(localized: "회"))")
                        .font(.caption)
                        .fontWeight(.bold)
                }

                if isSaved {
                    Label("기록 저장됨", systemImage: "checkmark")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

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
