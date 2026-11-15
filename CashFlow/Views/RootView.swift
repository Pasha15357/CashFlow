//
//  RootView.swift
//  CashFlow
//
//  Created by Паша on 12/13/25.
//

import Foundation
import SwiftUI

struct RootView: View {
    @AppStorage("didCompleteOnboarding")
    private var didCompleteOnboarding: Bool = false

    var body: some View {
        if didCompleteOnboarding {
            ContentView()
        } else {
            OnboardingView {
                didCompleteOnboarding = true
            }
        }
    }
}
