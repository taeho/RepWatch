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
// Hashable: NavigationPath에 값을 넣으려면 필수
enum BodyPart: String, CaseIterable, Hashable {
    case upper = "upper"
    case lower = "lower"

    var displayName: String {
        switch self {
        case .upper: return String(localized: "상체")
        case .lower: return String(localized: "하체")
        }
    }
}

struct WorkoutConfig: Hashable {
    var bodyPart: BodyPart = .upper
    var totalSets: Int = 3
    var targetReps: Int = 12
    var restCount: Int = 2
    var restDuration: Int = 60
}
