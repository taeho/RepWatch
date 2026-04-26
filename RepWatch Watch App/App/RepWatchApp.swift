//
//  RepWatchApp.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/26/26.
//

// RepWatchApp.swift
// 앱 진입점 - SwiftData 컨테이너를 최상위에서 주입

import SwiftUI
import SwiftData

@main
struct RepWatchApp: App {

    // SwiftData 컨테이너 생성
    // WorkoutRecord 모델을 로컬 DB에 등록
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([WorkoutRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("SwiftData 컨테이너 생성 실패: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)  // 전체 앱에 DB 주입
    }
}
