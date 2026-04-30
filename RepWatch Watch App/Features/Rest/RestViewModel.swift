//
//  RestViewModel.swift
//  RepWatch
//
//  Created by TaeHo Kang on 4/30/26.
//

import Foundation

class RestViewModel {
    let config: WorkoutConfig
    let workoutViewModel: WorkoutViewModel

    init(config: WorkoutConfig, workoutViewModel: WorkoutViewModel) {
        self.config = config
        self.workoutViewModel = workoutViewModel
    }
}
