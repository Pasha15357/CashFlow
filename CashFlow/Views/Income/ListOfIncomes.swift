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
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("\(settings.selectedCurrency.sign)\(Int(totalIncomesToday())) за сегодня")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(income) { income in
                        NavigationLink(destination: EditIncomeView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), income: income)) {
                            HStack {
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(income.name!)
                                        .bold()
                                    Text("\(settings.selectedCurrency.sign)\(Int(income.amount))").foregroundColor(.green)
                                    Text(income.category ?? "")
                                        .bold()
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
                AddIncomeView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
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
