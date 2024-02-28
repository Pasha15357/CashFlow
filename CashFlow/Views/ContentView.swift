//
//  ContentView.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedView = 1

    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedView){
                Main()
                    .tabItem {
                        Image(systemName: (self.selectedView == 1 ? "house" : "house.fill"))
                        Text("Главная")
                    }
                    .tag(1)
                ListOfExpenses()
                    .tabItem {
                        Image(systemName: (self.selectedView == 2 ? "list.bullet" : "list.bullet"))
                        Text("Список")
                    }
                    .tag(2)
                Settings()
                    .tabItem {
                        Image(systemName: (self.selectedView == 3 ? "gearshape" : "gearshape.fill"))
                        Text("Настройки")
                    }
                    .tag(3)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
