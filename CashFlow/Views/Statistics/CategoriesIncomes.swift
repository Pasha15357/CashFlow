//
//  CategoriesIncomes.swift
//  CashFlow
//
//  Created by Паша on 4.06.24.
//

import SwiftUI

struct CategoriesIncomes: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: [], animation: .default) private var incomes: FetchedResults<Income>
    
    @State private var selectedPeriod: Period = .today // Сделаем selectedPeriod состоянием
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredIncomes: [Income] = []
    let dateFormatter = DateFormatter()
    
    @State private var showingAddView = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var income: FetchedResults<Income>
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    var body: some View {
        VStack (alignment: .leading){
            List {
                ForEach(categories) { category in
                    if totalIncomesCategory(category: category.name ?? "") != 0 {
                        NavigationLink(destination: ListOfIncomesCategories(category: category)) {
                            HStack {
                                Image(systemName: "\(category.image!)")
                                    .frame(width: 30) // Установите требуемый размер изображения
                                Text(category.name!)
                                    .bold()
                                Spacer()
                                Text("\(totalIncomesCategory(category: category.name ?? "")) \(settings.selectedCurrency.sign)")
                                    .foregroundColor(.green)
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
                    Text("\(Int(totalIncomes())) \(settings.selectedCurrency.sign)")
                        .foregroundColor(.green)
                    Spacer()
                        .frame(width: 18)
                }
            }
        }
        .navigationBarTitle("Доходы")
        .sheet(isPresented: $showingAddView) {
            AddCategory()
        }
        .onAppear {
            loadUserDefaults()
            updateFilteredIncomes()
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalIncomesCategory(category: String) -> Int {
        var amount: Int = 0
        for item in filteredIncomes {
            if category == item.category {
                amount += Int(item.amount)
            }
        }
        return amount
    }
    
    private func totalIncomes() -> Double {
        var amount: Double = 0
        for item in filteredIncomes {
            amount += item.amount
        }
        return amount
    }
    
    func updateFilteredIncomes() {
        let (adjustedStartDate, adjustedEndDate) = startDate <= endDate ? (startDate, endDate) : (endDate, startDate)
        
        switch selectedPeriod {
        case .today:
            let startDate = Calendar.current.startOfDay(for: Date()) // Начало сегодняшнего дня
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)! // Конец сегодняшнего дня
            filteredIncomes = incomes.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        case .allTime:
            filteredIncomes = Array(incomes)
        case .lastMonth:
            guard let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) else { return }
            let endOfMonth = Calendar.current.startOfDay(for: Date()) // Начало сегодняшнего дня
            let endOfMonth1 = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth)!
            filteredIncomes = incomes.filter { ($0.date ?? Date()).isBetween(startOfMonth, and: endOfMonth1) }
        case .custom:
            filteredIncomes = incomes.filter { ($0.date ?? Date()).isBetween(adjustedStartDate, and: adjustedEndDate) }
        }
    }
    
    private func loadUserDefaults() {
        if let periodString = UserDefaults.standard.string(forKey: "incomeSelectedPeriod"),
           let period = Period(rawValue: periodString) {
            selectedPeriod = period
        }
        startDate = UserDefaults.standard.object(forKey: "incomeStartDate") as? Date ?? Date()
        endDate = UserDefaults.standard.object(forKey: "incomeEndDate") as? Date ?? Date()
    }
}

#Preview {
    CategoriesIncomes()
}

