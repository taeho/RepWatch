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

    // 외부에서 받지 않고 여기서 직접 생성
    @State private var workoutPath = NavigationPath()

    var body: some View {
        TabView {
            NavigationStack(path: $workoutPath) {
                SetupView(navigationPath: $workoutPath)
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
