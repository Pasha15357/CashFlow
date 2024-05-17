//
//  Expenses.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import CoreData

class Settings1: ObservableObject {
    @Published var selectedCurrencyIndex: Int = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
    
    struct Currency {
        var name: String
        var systemImageName: String
        var sign: String
    }
    
    var currencies: [Currency] = [
        Currency(name: "Доллар", systemImageName: "dollarsign.circle", sign: "$"),
        Currency(name: "Рубль", systemImageName: "rublesign.circle", sign: "₽"),
        Currency(name: "Евро", systemImageName: "eurosign.circle", sign: "€")
    ]
    
    var selectedCurrency: Currency {
        return currencies[selectedCurrencyIndex]
    }
}

struct ListOfExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    @FetchRequest var category: FetchedResults<Category>

    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(settings.selectedCurrency.sign)\(Int(totalExpensesToday())) за сегодня") // Используйте выбранную валюту из Settings
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(expense) { expense in
                        NavigationLink(destination: EditExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), expense: expense)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(expense.name!)
                                        .bold()
                                    
                                    Text("\(settings.selectedCurrency.sign)\(Int(expense.amount)) ").foregroundColor(.red) // Используйте выбранную валюту из Settings
                                    HStack {
                                        Image(systemName: "\(findCategoryImage(for: expense.category ?? ""))")
                                        Text(expense.category!)
                                            .bold()
                                    }
                                }
                                Spacer()
                                Text(calcTimeSince(date: expense.date!))
                                    .foregroundColor(.gray)
                                    .italic()
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
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
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
    
    private func totalExpensesToday() -> Double {
        var amountToday: Double = 0
        for item in expense {
            if Calendar.current.isDateInToday(item.date!) {
                amountToday += item.amount
            }
        }
        
        return amountToday
    }
    
    private func findCategoryImage(for categoryName: String) -> String {
        for cat in category {
            if cat.name == categoryName {
                return cat.image ?? "defaultImage" // Replace "defaultImage" with a default image name if needed
            }
        }
        return "defaultImage"
    }
}

#Preview {
    ListOfExpenses(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
}
