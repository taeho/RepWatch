//
//  AppState.swift
//  RepWatch
//
//  Created by TaeHo Kang on 5/20/26.
//

// AppState.swift
// 앱 전역 상태 관리
// ContentView가 소유하고 Environment로 하위 뷰에 주입

import Foundation
import Observation

@Observable
class AppState {
    var shouldResetToRoot: Bool = false
}
