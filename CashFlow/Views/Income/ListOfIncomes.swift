//
//  ListOfIncomes.swift
//  CashFlow
//
//  Created by Паша on 29.02.24.
//

import SwiftUI

struct ListOfIncomes: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var income: FetchedResults<Income>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("\(Int(totalIncomesToday())) рублей за сегодня")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(income) { income in
                        NavigationLink(destination: EditIncomeView(income: income)) {
                            HStack {
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(income.name!)
                                        .bold()
                                    
                                    Text("\(Int(income.amount)) рублей").foregroundColor(.green)
                                    
                                }
                                Spacer()
                                Text(calcTimeSince(date: income.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteIncome)
                }
                .listStyle(.plain)
                
            }
            .navigationTitle("Доходы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Добавить доход", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddIncomeView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { income[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalIncomesToday() -> Double {
        var amountToday : Double = 0
        for item in income {
            if Calendar.current.isDateInToday(item.date!) {
                amountToday += item.amount
            }
        }
        
        return amountToday
    }
    
}

#Preview {
    ListOfIncomes()
}
