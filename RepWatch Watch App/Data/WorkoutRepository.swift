//
//  WorkoutRepository.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// WorkoutRepository.swift
// SwiftData DB CRUD 담당
// 운동 기록 저장 / 조회 / 삭제

import Foundation
import SwiftData

struct WorkoutRepository {

    // MARK: - 저장

    static func save(
        context: ModelContext,
        config: WorkoutConfig,
        actualReps: [Int]
    ) {
        let record = WorkoutRecord(
            date: .now,
            bodyPart: config.bodyPart.rawValue,
            totalSets: config.totalSets,
            targetReps: config.targetReps,
            actualReps: actualReps,
            completedSets: actualReps.count,
            restCount: config.restCount,
            restDuration: config.restDuration
        )
        context.insert(record)

        do {
            try context.save()
        } catch {
            print("❌ 저장 실패: \(error)")
        }
    }

    // MARK: - 전체 조회 (최신순)

    static func fetchAll(context: ModelContext) -> [WorkoutRecord] {
        let descriptor = FetchDescriptor<WorkoutRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("❌ 조회 실패: \(error)")
            return []
        }
    }

    // MARK: - 삭제

    static func delete(context: ModelContext, record: WorkoutRecord) {
        context.delete(record)
        do {
            try context.save()
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }
}
