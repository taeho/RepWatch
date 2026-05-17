//
//  HistoryViewModel.swift
//  RepWatch
//
//  Created by TaeHo Kang on 5/17/26.
//

// HistoryViewModel.swift
// 운동 기록 목록 상태 관리

import Foundation
import Observation
import SwiftData

@Observable
class HistoryViewModel {

    // MARK: - Properties

    var records: [WorkoutRecord] = []

    // MARK: - 기록 불러오기

    func loadRecords(context: ModelContext) {
        records = WorkoutRepository.fetchAll(context: context)
    }

    // MARK: - 기록 삭제

    func delete(record: WorkoutRecord, context: ModelContext) {
        WorkoutRepository.delete(context: context, record: record)
        loadRecords(context: context)
    }

    // MARK: - 날짜 포맷

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    // MARK: - 운동 요약 텍스트

    func summaryText(_ record: WorkoutRecord) -> String {
        let bodyPart = record.bodyPart == "upper" ? "상체" : "하체"
        let totalReps = record.actualReps.reduce(0, +)
        return "\(bodyPart) · \(record.completedSets)세트 · \(totalReps)회"
    }
}
