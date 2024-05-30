//
//  ListOfExpensesCategories.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct ListOfExpensesCategories: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expense>
    var category: FetchedResults<Category>.Element

    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var selectedPeriod: Period = .today
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredExpenses: [Expense] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Категория - \(category.name ?? "")") // Используйте выбранную валюту из Settings
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(filteredExpenses) { expense in
                    if expense.category == category.name {
                        NavigationLink(destination: EditExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), expense: expense)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
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
            loadUserDefaults()
            updateFilteredExpenses()
        }
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func updateFilteredExpenses() {
        let (adjustedStartDate, adjustedEndDate) = startDate <= endDate ? (startDate, endDate) : (endDate, startDate)
        
        switch selectedPeriod {
        case .today:
            let startDate = Calendar.current.startOfDay(for: Date()) // Начало сегодняшнего дня
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)! // Конец сегодняшнего дня
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        case .allTime:
            filteredExpenses = Array(expenses)
        case .lastMonth:
            guard let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) else { return }
            let endOfMonth = Calendar.current.startOfDay(for: Date()) // Начало сегодняшнего дня
            let endOfMonth1 = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth)!
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startOfMonth, and: endOfMonth1) }
        case .custom:
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(adjustedStartDate, and: adjustedEndDate) }
        }
    }
    
    private func loadUserDefaults() {
        if let periodString = UserDefaults.standard.string(forKey: "selectedPeriod"),
           let period = Period(rawValue: periodString) {
            selectedPeriod = period
        }
        startDate = UserDefaults.standard.object(forKey: "startDate") as? Date ?? Date()
        endDate = UserDefaults.standard.object(forKey: "endDate") as? Date ?? Date()
    }
}

#Preview {
    ListOfExpensesCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil).wrappedValue.first!)
}
