//
//  Expenses.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import CoreData

struct ListOfExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>


    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    @State private var searchText = ""
    @State private var showSearchBar = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalExpensesToday())) \(settings.selectedCurrency.sign) за сегодня")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(filteredExpenses) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(expense.name!)
                                        .bold()
                                    
                                    Text("\(Int(expense.amount)) \(settings.selectedCurrency.sign) ").foregroundColor(.red)
                                    HStack {
                                        Image(systemName: "\(findCategoryImage(for: expense.category ?? ""))")
                                        
                                        Text(expense.category!)
                                            .foregroundColor(.gray)
//                                            .bold()
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
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private var filteredExpenses: [Expense] {
        if searchText.isEmpty {
            return expense.map { $0 }
        } else {
            return expense.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
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
        for cat in categories {
            if cat.name == categoryName {
                return cat.image ?? "defaultImage"
            }
        }
        return "defaultImage"
    }
}

#Preview {
    ListOfExpenses()
}
