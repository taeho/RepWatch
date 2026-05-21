//
//  MotionService.swift
//  RepWatch
//
//  Created by TaeHo Kang on 5/17/26.
//

// MotionService.swift
// Core Motion 센서 기반 자동 렙 카운팅 알고리즘
//
// 동작 원리:
// 1. deviceMotion으로 중력 제거된 순수 가속도 수집 (50Hz)
// 2. EMA 필터로 노이즈 제거
// 3. 상태머신으로 렙 감지 (IDLE → RISING → COOLDOWN)
// 4. 임계값/쿨다운은 실기기 튜닝 파라미터로 분리

import CoreMotion
import Foundation
import Observation

@Observable
class MotionService {

    // MARK: - 감지 상태머신¹
    private enum DetectionState {
        case idle       // 대기 - 움직임 없음
        case rising     // 임계값 초과 - 동작 시작 감지
        case cooldown   // 렙 카운팅 후 대기 (중복 감지 방지)
    }

    // MARK: - 디버그용 공개 프로퍼티
    var currentMagnitude: Double = 0.0   // 현재 가속도 크기 (UI 표시용)
    var isAvailable: Bool = false        // 센서 사용 가능 여부

    // MARK: - 튜닝 파라미터 (실기기 테스트 후 조정)
    // ⚙️ threshold: 낮을수록 민감 (오감지↑), 높을수록 둔감 (미감지↑)
    // ⚙️ debounceInterval: 렙 사이 최소 간격 - 너무 짧으면 1동작에 2카운트
    var threshold: Double = 0.6          // 렙 감지 임계값 (g 단위²)
    var debounceInterval: Double = 0.8   // 렙 사이 최소 간격 (초)

    // MARK: - Private
    private let motionManager = CMMotionManager()
    private var detectionState: DetectionState = .idle
    private var lastRepTime: Date = .distantPast
    private var filteredMagnitude: Double = 0.0
    private let filterFactor: Double = 0.4  // EMA 필터³ 계수 (0=필터 없음, 1=완전 평탄화)
    private var onRepCounted: (() -> Void)?

    // MARK: - 카운팅 시작

    func startCounting(onRepCounted: @escaping () -> Void) {
        self.onRepCounted = onRepCounted

        guard motionManager.isDeviceMotionAvailable else {
            print("⚠️ Device Motion 사용 불가")
            isAvailable = false
            return
        }

        isAvailable = true
        detectionState = .idle
        lastRepTime = .distantPast

        // 50Hz로 샘플링 (0.02초 간격)
        motionManager.deviceMotionUpdateInterval = 0.02
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self, let motion else { return }
            self.processMotion(motion)
        }
    }

    // MARK: - 카운팅 정지

    func stopCounting() {
        motionManager.stopDeviceMotionUpdates()
        detectionState = .idle
        filteredMagnitude = 0.0
        currentMagnitude = 0.0
    }

    // MARK: - 모션 처리 핵심 로직

    private func processMotion(_ motion: CMDeviceMotion) {

        // 1단계: 중력 제거된 순수 사용자 가속도⁴ 추출
        let acc = motion.userAcceleration
        let rawMagnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z)

        // 2단계: EMA 필터로 노이즈 제거
        filteredMagnitude = filteredMagnitude * (1 - filterFactor) + rawMagnitude * filterFactor
        currentMagnitude = filteredMagnitude

        let now = Date()
        let timeSinceLastRep = now.timeIntervalSince(lastRepTime)

        // 3단계: 상태머신으로 렙 감지
        switch detectionState {

        case .idle:
            // 임계값 초과 + 쿨다운 경과 → 동작 시작
            if filteredMagnitude > threshold && timeSinceLastRep > debounceInterval {
                detectionState = .rising
            }

        case .rising:
            // 가속도가 임계값 50% 아래로 내려오면 렙 완료로 판정
            // (피크 후 하강 = 동작 1회 완료)
            if filteredMagnitude < threshold * 0.5 {
                detectionState = .cooldown
                lastRepTime = now
                onRepCounted?()
            }

        case .cooldown:
            // 쿨다운 시간 경과 후 다시 대기 상태로
            if timeSinceLastRep > debounceInterval {
                detectionState = .idle
            }
        }
    }
}
