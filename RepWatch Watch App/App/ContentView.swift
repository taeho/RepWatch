//
//  ContentView.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//
// ContentView.swift
// 앱 루트 - 탭뷰로 [운동시작 / 기록] 두 섹션 구성

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 탭 1: 운동 설정 시작
            NavigationStack {
                SetupView()
            }
            .tabItem { Label("운동", systemImage: "figure.strengthtraining.traditional") }

            // 탭 2: 운동 기록
            NavigationStack {
                HistoryView()
            }
            .tabItem { Label("기록", systemImage: "list.bullet") }
        }
    }
}
