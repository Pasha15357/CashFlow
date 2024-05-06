//
//  ListOfExpensesCategories.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct ListOfExpensesCategories: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    var category : FetchedResults<Category>.Element

    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    var body: some View {
            VStack(alignment: .leading){
                Text("Категория - \(category.name ?? "")") // Используйте выбранную валюту из Settings
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(expense) { expense in
                        if expense.category == category.name{
                            NavigationLink(destination: EditExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), expense: expense)) {
                                HStack {
                                    VStack (alignment: .leading, spacing: 6) {
                                        Text(expense.name!)
                                            .bold()
                                        
                                        Text("\(settings.selectedCurrency.sign)\(Int(expense.amount)) ").foregroundColor(.red) // Используйте выбранную валюту из Settings
                                        
                                    }
                                    Spacer()
                                    Text(calcTimeSince(date: expense.date!))
                                        .foregroundColor(.gray)
                                        .italic()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Расходы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Добавить расход", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
        .navigationViewStyle(.stack)
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expense[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalExpenses() -> Double {
        var amount : Double = 0
        for item in expense {
            amount += item.amount
        }
        
        return amount
    }
}

//#Preview {
//    ListOfExpensesCategories()
//}
