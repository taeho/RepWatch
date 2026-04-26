//
//  WorkoutConfig.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
// WorkoutConfig.swift
// 운동 설정값을 담는 값 타입(구조체)
// View 간 전달용, DB 저장 안 함

import Foundation

// 운동 부위
enum BodyPart: String, CaseIterable {
    case upper = "upper"
    case lower = "lower"

    var displayName: String {
        switch self {
        case .upper: return "상체"
        case .lower: return "하체"
        }
    }
}

// 운동 시작 전 설정값 묶음
struct WorkoutConfig {
    var bodyPart: BodyPart = .upper
    var totalSets: Int = 3         // 전체 세트 수
    var targetReps: Int = 12       // 세트당 목표 횟수
    var restCount: Int = 2         // 휴식 횟수 (0 = 휴식 없음)
    var restDuration: Int = 60     // 휴식 시간 (초)
}
