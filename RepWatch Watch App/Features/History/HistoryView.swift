//
//  HistoryView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//

// HistoryView.swift
// 운동 기록 목록 및 상세 화면
import SwiftUI
import SwiftData

struct HistoryView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HistoryViewModel()

    var body: some View {
        Group {
            if viewModel.records.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                    Text("기록 없음")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                List {
                    ForEach(viewModel.records) { record in
                        NavigationLink {
                            HistoryDetailView(record: record)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.formattedDate(record.date))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text(viewModel.summaryText(record))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.delete(
                                record: viewModel.records[index],
                                context: modelContext
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("기록")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadRecords(context: modelContext)
        }
    }
}

// MARK: - 기록 상세 화면

struct HistoryDetailView: View {

    let record: WorkoutRecord

    private var totalReps: Int {
        record.actualReps.reduce(0, +)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {

                Text(formattedFullDate(record.date))
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    // ✅ String(localized:) 적용
                    InfoRow(
                        label: String(localized: "부위"),
                        value: record.bodyPart == "upper"
                            ? String(localized: "상체")
                            : String(localized: "하체")
                    )
                    InfoRow(
                        label: String(localized: "세트"),
                        value: "\(record.completedSets) / \(record.totalSets)"
                    )
                    InfoRow(
                        label: String(localized: "목표"),
                        value: "\(record.targetReps) \(String(localized: "회"))"
                    )
                    InfoRow(
                        label: String(localized: "총 횟수"),
                        value: "\(totalReps) \(String(localized: "회"))"
                    )

                    if record.restCount > 0 {
                        InfoRow(
                            label: String(localized: "휴식"),
                            value: "\(record.restCount)\(String(localized: "회")) / \(record.restDuration)\(String(localized: "초"))"
                        )
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text("세트별 기록")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    ForEach(Array(record.actualReps.enumerated()), id: \.offset) { index, reps in
                        HStack {
                            // ✅ 보간 수정
                            Text("\(index + 1)\(String(localized: "세트"))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            // ✅ 보간 수정
                            Text("\(reps)\(String(localized: "회"))")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(
                                    reps >= record.targetReps ? .green : .yellow
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("상세")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

// MARK: - InfoRow 컴포넌트

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption2)
                .fontWeight(.medium)
        }
    }
}
