import Foundation
import Observation

@Observable
class WorkoutViewModel {

    // MARK: - 기존 프로퍼티 유지 + 아래 추가
    let config: WorkoutConfig
    var currentSet: Int = 1
    var currentReps: Int = 0
    var actualReps: [Int] = []
    var isWorkoutActive: Bool = false
    var goToRest: Bool = false
    var goToComplete: Bool = false
    var remainingRestCount: Int

    // MotionService 추가
    private let motionService = MotionService()

    // 디버그용 - 현재 가속도 크기 (나중에 제거 가능)
    var currentMagnitude: Double {
        motionService.currentMagnitude
    }

    // MARK: - Init
    init(config: WorkoutConfig) {
        self.config = config
        self.remainingRestCount = config.restCount
    }

    // MARK: - 운동 시작 (수정)
    func startWorkout() {
        isWorkoutActive = true

        // 상체만 자동 카운팅, 하체는 더블탭 수동
        if config.bodyPart == .upper {
            motionService.startCounting { [weak self] in
                self?.addRep()
            }
        }
    }

    // MARK: - 렙 추가 (기존 유지)
    func addRep() {
        guard isWorkoutActive else { return }
        currentReps += 1
        HapticService.repCounted()

        if currentReps >= config.targetReps {
            completeSet()
        }
    }

    // MARK: - 세트 완료 (수정 - 센서 정지 추가)
    func completeSet() {
        isWorkoutActive = false
        motionService.stopCounting()      // 센서 정지
        actualReps.append(currentReps)
        HapticService.setComplete()

        if currentSet >= config.totalSets {
            goToComplete = true
        } else {
            if remainingRestCount > 0 {
                goToRest = true
            } else {
                moveToNextSet()
            }
        }
    }

    // MARK: - 다음 세트 이동 (수정 - 센서 재시작 추가)
    func moveToNextSet() {
        currentSet += 1
        currentReps = 0
        isWorkoutActive = true
        goToRest = false

        // 상체면 센서 재시작
        if config.bodyPart == .upper {
            motionService.startCounting { [weak self] in
                self?.addRep()
            }
        }
    }
    
    // MARK: - 운동 완전 종료 (홈으로 복귀 시)
    func stopWorkout() {
        isWorkoutActive = false
        motionService.stopCounting()
        goToComplete = false
        goToRest = false
    }
}
