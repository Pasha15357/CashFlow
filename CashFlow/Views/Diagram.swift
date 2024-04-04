//
//  Diagram.swift
//  CashFlow
//
//  Created by Паша on 4.04.24.
//

import SwiftUI
import Charts

struct ExpenseData {
    let name: String
    let amount: Int
}

struct Diagram: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var expenses: FetchedResults<Expense>

    var body: some View {
        NavigationView{
            VStack{
                Chart(expenses.map { expense in
                    ExpenseData(name: expense.name ?? "", amount: Int(expense.amount))
                }, id: \.name) { expense in
                    if #available(iOS 17.0, *) {
                        SectorMark(
                            angle: .value ("Macros", expense.amount),
                            innerRadius: .ratio(0.618),
                            angularInset: 1.5
                        )
                        .cornerRadius(4)
                        .foregroundStyle (by: .value("Name", expense.name))
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .frame(height: 300)
                .chartXAxis(.hidden)
            }
            .navigationTitle("Статистика")
            .padding()
        }
    }
}


#Preview {
    Diagram()
}
