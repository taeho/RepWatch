//
//  WorkoutRecord.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//
// WorkoutRecord.swift
// SwiftData DB 모델 - 완료된 운동 기록 저장용

import Foundation
import SwiftData

@Model
final class WorkoutRecord {

    // MARK: - Properties

    var id: UUID
    var date: Date
    var bodyPart: String           // "upper" / "lower"
    var totalSets: Int             // 목표 세트 수
    var targetReps: Int            // 세트당 목표 횟수
    var actualReps: [Int]          // 세트별 실제 완료 횟수 ex) [12, 11, 13]
    var completedSets: Int         // 실제 완료한 세트 수 (중단 대비)
    var restCount: Int             // 휴식 횟수
    var restDuration: Int          // 휴식 시간 (초), 0 = 휴식 없음

    // MARK: - Init

    init(
        date: Date = .now,
        bodyPart: String,
        totalSets: Int,
        targetReps: Int,
        actualReps: [Int] = [],
        completedSets: Int = 0,
        restCount: Int,
        restDuration: Int
    ) {
        self.id = UUID()
        self.date = date
        self.bodyPart = bodyPart
        self.totalSets = totalSets
        self.targetReps = targetReps
        self.actualReps = actualReps
        self.completedSets = completedSets
        self.restCount = restCount
        self.restDuration = restDuration
    }
}
