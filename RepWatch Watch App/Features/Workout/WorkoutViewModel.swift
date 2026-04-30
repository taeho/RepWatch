//
//  WorkoutViewModel.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// WorkoutViewModel.swift
// 운동 실행 화면 상태 관리
// MotionService는 Phase 3-③에서 연결 예정

import Foundation
import Observation

@Observable
class WorkoutViewModel {

    // MARK: - 운동 설정 (Setup에서 전달받음)
    let config: WorkoutConfig

    // MARK: - 운동 진행 상태
    var currentSet: Int = 1          // 현재 세트 (1부터 시작)
    var currentReps: Int = 0         // 현재 세트 완료 횟수
    var actualReps: [Int] = []       // 세트별 실제 완료 횟수 기록
    var isWorkoutActive: Bool = false // 운동 진행 중 여부

    // MARK: - 화면 전환 트리거
    var goToRest: Bool = false        // 휴식 화면으로 이동
    var goToComplete: Bool = false    // 완료 화면으로 이동

    // MARK: - 휴식 남은 횟수
    var remainingRestCount: Int       // 사용 가능한 휴식 횟수

    // MARK: - Init
    init(config: WorkoutConfig) {
        self.config = config
        self.remainingRestCount = config.restCount
    }

    // MARK: - 렙 수동 추가 (하체 더블탭 또는 테스트용)
    func addRep() {
        guard isWorkoutActive else { return }
        currentReps += 1
        HapticService.repCounted()

        // 목표 횟수 도달 시
        if currentReps >= config.targetReps {
            completeSet()
        }
    }

    // MARK: - 세트 완료 처리
    func completeSet() {
        isWorkoutActive = false
        actualReps.append(currentReps)   // 이번 세트 기록 저장
        HapticService.setComplete()

        // 마지막 세트 완료 여부 판단
        if currentSet >= config.totalSets {
            goToComplete = true
        } else {
            // 휴식 횟수 남아있으면 휴식, 아니면 바로 다음 세트
            if remainingRestCount > 0 {
                goToRest = true
            } else {
                moveToNextSet()
            }
        }
    }

    // MARK: - 다음 세트로 이동
    func moveToNextSet() {
        currentSet += 1
        currentReps = 0
        isWorkoutActive = true
        goToRest = false
    }

    // MARK: - 운동 시작
    func startWorkout() {
        isWorkoutActive = true
    }
}
