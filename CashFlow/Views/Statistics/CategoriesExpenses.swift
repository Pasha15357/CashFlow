//
//  CategoriesExpenses.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct CategoriesExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext

    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: [], animation: .default) private var expenses: FetchedResults<Expense>
    
    @State private var selectedPeriod: Period = .today // Сделаем selectedPeriod состоянием
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredExpenses: [Expense] = []
    let dateFormatter = DateFormatter()
    
    @State private var showingAddView = false
    
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    var body: some View {
        VStack (alignment: .leading){
            period()
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(categories) { category in
                    if totalExpensesCategory(category: category.name ?? "") != 0 {
                        NavigationLink(destination: ListOfExpensesCategories(category: category)) {
                            HStack {
                                Image(systemName: "\(category.image!)")
                                    .frame(width: 30) // Установите требуемый размер изображения
                                Text(category.name!)
                                    .bold()
                                Spacer()
                                Text("\(String(format: "%.2f", totalExpensesCategory(category: category.name ?? ""))) \(settings.selectedCurrency.sign)")
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
                    Text("\(settings.selectedCurrency.sign)\(String(format: "%.2f", totalExpenses()))")
                        .foregroundColor(.red)
                    Spacer()
                        .frame(width: 18)
                }
            }
            .listStyle(.plain)
        }
        .navigationBarTitle("Расходы", displayMode: .large)
        .sheet(isPresented: $showingAddView) {
            AddCategory()
        }
        .onAppear {
            loadUserDefaults()
            updateFilteredExpenses()
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    private func totalExpensesCategory(category: String) -> Double {
        var amount : Double = 0
        for item in filteredExpenses {
            if category == item.category {
                amount += item.amount
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
    
    func period() -> Text {
        let (_, _) = startDate <= endDate ? (startDate, endDate) : (endDate, startDate)
       
       switch selectedPeriod {
       case .today:
           return Diagram().dateForToday()
       case .allTime:
           return Text("Весь период")
       case .lastMonth:
           return Diagram().dateForMonth()
       case .custom:
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "d MMMM yyyy"
           let startDate1 = dateFormatter.string(from: startDate)
           let endDate1 = dateFormatter.string(from: endDate)
           return Text("С \(startDate1) по \(endDate1)")
       }
   }
    
    func updateFilteredExpenses() {
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
    CategoriesExpenses()
}
