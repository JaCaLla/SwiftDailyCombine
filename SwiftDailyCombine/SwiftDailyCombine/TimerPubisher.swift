//
//  TimerPubisher.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 26/2/26.
//

import Foundation
import Combine

func setupTimer() {
    Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .scan(0) { count, _ in count + 1 }  // contador
        .sink { value in
            print("Segundos:", value)
        }
        .store(in: &cancellables)
}

