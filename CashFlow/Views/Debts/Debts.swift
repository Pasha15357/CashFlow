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
    @FetchRequest(entity: Lent.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lent.dateTaken, ascending: false)]) var lents: FetchedResults<Lent>

    @State private var showingAddDebtView = false
    @State private var showingAddLentView = false

    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            VStack {
                Picker("Тип долгов", selection: $selectedTab) {
                    Text("Я должен").tag(0)
                    Text("Мне должны").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    if selectedTab == 1 {
                        ForEach(lents) { lent in
                            NavigationLink(destination: EditLent(lent: lent)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(lent.contactName ?? "")")
                                            .font(.headline)
                                        Text("Сумма: \(lent.amountOwed, specifier: "%.2f")")
                                        Text("Взял: \(lent.dateTaken ?? Date(), formatter: dateFormatter)")
                                        Text("Вернет: \(lent.dateDue ?? Date(), formatter: dateFormatter)")
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onDelete { indices in
                            indices.map { debts[$0] }.forEach(managedObjectContext.delete)
                            try? managedObjectContext.save()
                        }
                    } else {
                        ForEach(debts) { debt in
                            NavigationLink(destination: EditDebt(debt: debt)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(debt.contactName ?? "")")
                                            .font(.headline)
                                        Text("Сумма: \(debt.amountOwed, specifier: "%.2f")")
                                        Text("Взяли: \(debt.dateTaken ?? Date(), formatter: dateFormatter)")
                                        Text("Вернёте: \(debt.dateDue ?? Date(), formatter: dateFormatter)")
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onDelete { indices in
                            indices.map { debts[$0] }.forEach(managedObjectContext.delete)
                            try? managedObjectContext.save()
                        }
                    }
                }
                .listStyle(.plain)
            }
            
        }
        .navigationBarTitle("Долги")
        .navigationBarItems(trailing: Button(action: {
            if selectedTab == 1 {
                showingAddLentView = true
            } else {
                showingAddDebtView = true
            }
        }) {
            Image(systemName: "plus.circle")
        })
        .sheet(isPresented: $showingAddDebtView) {
            AddDebt().environment(\.managedObjectContext, managedObjectContext)
        }
        .sheet(isPresented: $showingAddLentView) {
            AddLent().environment(\.managedObjectContext, managedObjectContext)
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
