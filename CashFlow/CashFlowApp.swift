//
//  CashFlowApp.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI

@main
struct CashFlowApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
