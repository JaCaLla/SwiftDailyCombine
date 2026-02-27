//
//  NotificationCenter.swift
//  SwiftDailyCombine
//
//  Created by Javier Calatrava on 26/2/26.
//
import Combine
import Foundation
import UIKit

func classicUsage() {
    NotificationCenter.default.addObserver(
        forName: UIApplication.didBecomeActiveNotification,
        object: nil,
        queue: .main
    ) { _ in
        print("App activa")
    }
}

func combineUsage() {
    NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        .sink { _ in
            print("App active")
        }
        .store(in: &cancellables)
}
