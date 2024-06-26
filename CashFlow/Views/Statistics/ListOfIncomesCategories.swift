//
//  ListOfIncomesCategories.swift
//  CashFlow
//
//  Created by Паша on 4.06.24.
//

import SwiftUI

struct ListOfIncomesCategories: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var incomes: FetchedResults<Income>
    var category: FetchedResults<Category>.Element

    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var selectedPeriod: Period = .today
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredIncomes: [Income] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Категория - \(category.name ?? "")") // Используйте выбранную валюту из Settings
                .foregroundColor(.gray)
                .padding(.horizontal)
            List {
                ForEach(filteredIncomes) { income in
                    if income.category == category.name {
                        NavigationLink(destination: EditIncomeView(income: income)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(income.name!)
                                        .bold()
                                    
                                    Text("\(Int(income.amount)) \(settings.selectedCurrency.sign)").foregroundColor(.green) // Используйте выбранную валюту из Settings
                                }
                                Spacer()
                                Text(calcTimeSince(date: income.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
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
        }
        .sheet(isPresented: $showingAddView) {
            AddIncomeView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
            loadUserDefaults()
            updateFilteredIncomes()
        }
    }
    
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func updateFilteredIncomes() {
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
    ListOfIncomesCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil).wrappedValue.first!)
}

