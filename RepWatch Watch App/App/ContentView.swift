//
//  ContentView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//
// ContentView.swift
// 앱 루트 - 탭뷰로 [운동시작 / 기록] 두 섹션 구성
// ContentView.swift 수정
// NavigationStack에 path 추가 → 루트로 한번에 복귀 가능
import SwiftUI

struct ContentView: View {

    @State private var workoutPath = NavigationPath()
    @State private var appState = AppState()

    var body: some View {
        TabView {
            NavigationStack(path: $workoutPath) {
                SetupView(navigationPath: $workoutPath)
                    // WorkoutConfig 값으로 WorkoutView 열기
                    .navigationDestination(for: WorkoutConfig.self) { config in
                        WorkoutView(viewModel: WorkoutViewModel(config: config))
                    }
            }
            .environment(appState)
            .onChange(of: appState.shouldResetToRoot) { _, newValue in
                if newValue {
                    workoutPath = NavigationPath()       // 이제 WorkoutView도 제거됨 ✅
                    appState.shouldResetToRoot = false
                }
            }
            .tabItem {
                Label("운동", systemImage: "figure.strengthtraining.traditional")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("기록", systemImage: "list.bullet")
            }
        }
    }
}
