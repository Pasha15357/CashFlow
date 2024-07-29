//
//  Debts.swift
//  CashFlow
//
//  Created by Паша on 3.07.24.
//

import SwiftUI
import CoreData

struct Debts: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Debt.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Debt.dateTaken, ascending: false)]) var debts: FetchedResults<Debt>
    @State private var showingAddDebtView = false
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                Picker("Тип долгов", selection: $selectedTab) {
                    Text("Я должен").tag(0)
                    Text("Мне должны").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(debts.filter { $0.isDebtOwedToMe == (selectedTab == 1) }) { debt in
                        VStack(alignment: .leading) {
                            Text("\(debt.contactName ?? "")")
                                .font(.headline)
                            Text("Сумма: \(debt.amount, specifier: "%.2f")")
                            Text("Дата взятия: \(debt.dateTaken ?? Date(), formatter: dateFormatter)")
                            Text("Дата возврата: \(debt.dateDue ?? Date(), formatter: dateFormatter)")
                        }
                    }
                    .onDelete { indices in
                        indices.map { debts[$0] }.forEach(managedObjectContext.delete)
                        try? managedObjectContext.save()
                    }
                }
            }
            .navigationBarTitle("Долги")
            .navigationBarItems(trailing: Button(action: {
                showingAddDebtView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddDebtView) {
                AddDebt().environment(\.managedObjectContext, managedObjectContext)
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()




#Preview {
    Debts()
}
