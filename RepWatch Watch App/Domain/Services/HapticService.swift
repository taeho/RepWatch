//
//  HapticService.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// HapticService.swift
// Apple Watch 햅틱 진동 담당
// WKInterfaceDevice.current().play()로 다양한 패턴 제공

import WatchKit

struct HapticService {

    // MARK: - 세트 완료 진동
    // 목표 횟수 도달 시 - 강하고 명확한 진동
    static func setComplete() {
        WKInterfaceDevice.current().play(.success)
    }

    // MARK: - 휴식 종료 진동
    // 타이머 완료 시 - 주의를 끄는 반복 진동
    static func restComplete() {
        WKInterfaceDevice.current().play(.notification)
    }

    // MARK: - 운동 전체 완료 진동
    // 모든 세트 완료 시 - 축하 패턴
    static func workoutComplete() {
        WKInterfaceDevice.current().play(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            WKInterfaceDevice.current().play(.success)
        }
    }

    // MARK: - 카운팅 진동
    // 렙 1회 감지 시 - 짧고 가벼운 진동
    static func repCounted() {
        WKInterfaceDevice.current().play(.click)
    }
}
