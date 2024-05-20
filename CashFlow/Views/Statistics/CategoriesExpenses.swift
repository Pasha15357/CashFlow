//
//  CategoriesExpenses.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct CategoriesExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest var category: FetchedResults<Category>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: [], animation: .default) private var expenses: FetchedResults<Expense>
    
    var selectedPeriod: Period

    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredExpenses: [Expense] = []
    let dateFormatter = DateFormatter()
    
    @State private var showingAddView = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    var body: some View {
        VStack (alignment: .leading){
            List {
                ForEach(category) { category in
                    if totalExpensesCategory(category: category.name ?? "") != 0 {
                        NavigationLink(destination: ListOfExpensesCategories(category: category, selectedPeriod: selectedPeriod)) {
                            HStack {
                                Image(systemName: "\(category.image!)")
                                    .frame(width: 30) // Установите требуемый размер изображения
                                Text(category.name!)
                                    .bold()
                                Spacer()
                                Text("\(settings.selectedCurrency.sign)\(totalExpensesCategory(category: category.name ?? ""))")
                                    .foregroundColor(.red)
                                
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteCategory)
                HStack {
                    Spacer()
                        .frame(width: 38)
                    Text("Итого:")
                        .bold()
                    Spacer()
                    Text("\(settings.selectedCurrency.sign)\(Int(totalExpenses()))")
                        .foregroundColor(.red)
                    Spacer()
                        .frame(width: 18)
                }
            }
        }
        .navigationBarTitle("Расходы")
        .sheet(isPresented: $showingAddView) {
            AddCategory()
        }
        .onAppear {
            updateFilteredExpenses()
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { category[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    private func totalExpensesCategory(category: String) -> Int {
        var amount : Int = 0
        for item in filteredExpenses {
            if category == item.category {
                amount += Int(item.amount)
            }
        }
        return amount
    }
    
    private func totalExpenses() -> Double {
        var amount : Double = 0
        for item in filteredExpenses {
            amount += item.amount
        }
        
        return amount
    }
    
    func updateFilteredExpenses() {
        switch selectedPeriod {
        case .today:
            let startDate = Calendar.current.startOfDay(for: Date()) // Начало сегодняшнего дня
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)! // Конец сегодняшнего дня
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        case .allTime:
            filteredExpenses = Array(expenses)
        case .lastMonth:
            guard let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) else { return }
            let endOfMonth = Calendar.current.startOfDay(for: Date())
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startOfMonth, and: endOfMonth) }
        case .custom:
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        }
    }
}

#Preview {
    CategoriesExpenses(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), selectedPeriod: .today)
}

