//
//  ContentView.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI

struct ContentView: View {
    
    @State public var selectedView = 1

    
    var body: some View {
        TabView(selection: $selectedView){
            Main(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), selectedView: $selectedView)
                .tabItem {
                    Image(systemName: (self.selectedView == 1 ? "house" : "house.fill"))
                    Text("Главная")
                }
                .tag(1)
            ListOfExpenses(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
                .tabItem {
                    Image(systemName: (self.selectedView == 2 ? "minus.rectangle" : "minus.rectangle"))
                    Text("Расходы")
                }
                .tag(2)
            ListOfIncomes(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
                .tabItem {
                    Image(systemName: (self.selectedView == 3 ? "plus.rectangle" : "plus.rectangle"))
                    Text("Доходы")
                }
                .tag(3)
            Diagram()
                .tabItem {
                    Image(systemName: (self.selectedView == 4 ? "chart.bar.xaxis.ascending" : "chart.bar.xaxis.ascending"))
                    Text("Статистика")
                }
                .tag(4)
            Settings()
                .tabItem {
                    Image(systemName: (self.selectedView == 4 ? "gearshape" : "gearshape.fill"))
                    Text("Настройки")
                }
                .tag(5)
            
        }

    }
}

#Preview {
    ContentView()
}
