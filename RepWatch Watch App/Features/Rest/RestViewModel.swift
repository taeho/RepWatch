//
//  RestViewModel.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

// RestViewModel.swift
// 휴식 타이머 상태 관리
// 타이머 종료 또는 Skip 시 다음 세트로 이동

import Foundation
import Observation

@Observable
class RestViewModel {

    // MARK: - Properties

    let config: WorkoutConfig
    let workoutViewModel: WorkoutViewModel

    var remainingSeconds: Int        // 남은 휴식 시간 (초)
    var isRestActive: Bool = false   // 타이머 동작 중 여부

    private var timer: Timer?

    // MARK: - Init

    init(config: WorkoutConfig, workoutViewModel: WorkoutViewModel) {
        self.config = config
        self.workoutViewModel = workoutViewModel
        self.remainingSeconds = config.restDuration
    }

    // MARK: - 타이머 시작

    func startRest() {
        isRestActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.remainingSeconds > 1 {
                self.remainingSeconds -= 1
            } else {
                self.restFinished()
            }
        }
    }

    // MARK: - 타이머 종료 (자동)

    private func restFinished() {
        stopTimer()
        HapticService.restComplete()
        moveToNextSet()
    }

    // MARK: - Skip 버튼

    func skip() {
        stopTimer()
        moveToNextSet()
    }

    // MARK: - 타이머 정지

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRestActive = false
    }

    // MARK: - 다음 세트로 이동

    private func moveToNextSet() {
        workoutViewModel.remainingRestCount -= 1  // 휴식 횟수 차감
        workoutViewModel.moveToNextSet()           // WorkoutView로 복귀
    }
}
