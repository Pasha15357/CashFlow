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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expense>
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>


    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    @State private var sortOption: String = "date_desc"

    @State private var searchText = ""
    @State private var showSearchBar = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                if filteredExpenses.isEmpty {
                    VStack {
                        Spacer()
                        Text("Нет расходов")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                }
                else {
                    HStack {
                        Text("\(String(format: "%.2f", totalExpensesToday())) \(settings.selectedCurrency.sign) за сегодня")
                            .foregroundColor(.gray)

                        Spacer()

                        Picker("Сортировка", selection: $sortOption) {
                            Text("По дате ↓").tag("date_desc")
                            Text("По дате ↑").tag("date_asc")
                            Text("Сумма ↓").tag("amount_desc")
                            Text("Сумма ↑").tag("amount_asc")
                            Text("Название А→Я").tag("name_asc")
                            Text("Название Я→А").tag("name_desc")
                            Text("Категория А→Я").tag("category_asc")
                            Text("Категория Я→А").tag("category_desc")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(filteredExpenses) { expense in
                            NavigationLink(destination: EditExpenseView(expense: expense)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(expense.name!)
                                            .bold()
                                        
                                        Text("\(String(format: "%.2f",expense.amount)) \(settings.selectedCurrency.sign) ").foregroundColor(.red)
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
                AddExpenseView()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private var filteredExpenses: [Expense] {
        var list = expenses.map { $0 }

        if !searchText.isEmpty {
            list = list.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }

        switch sortOption {
        case "date_asc":
            list = list.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
        case "amount_desc":
            list = list.sorted { $0.amount > $1.amount }
        case "amount_asc":
            list = list.sorted { $0.amount < $1.amount }
        case "name_asc":
            list = list.sorted { ($0.name ?? "") < ($1.name ?? "") }
        case "name_desc":
            list = list.sorted { ($0.name ?? "") > ($1.name ?? "") }
        case "category_asc":
            list = list.sorted { ($0.category ?? "") < ($1.category ?? "") }
        case "category_desc":
            list = list.sorted { ($0.category ?? "") > ($1.category ?? "") }
        default:
            list = list.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
        }

        return list
    }

    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalExpensesToday() -> Double {
        var amountToday: Double = 0
        for item in expenses {
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
