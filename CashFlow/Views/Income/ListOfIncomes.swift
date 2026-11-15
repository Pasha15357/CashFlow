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
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>

    
    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    @State private var sortOption: String = "date_desc"

    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if filteredIncomes.isEmpty {
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
                        Text("\(String(format: "%.2f", totalIncomesToday())) \(settings.selectedCurrency.sign) за сегодня")
                            .foregroundColor(.gray)

                        Spacer()

                        Picker("Сортировка", selection: $sortOption) {
                            Text("По дате ↓").tag("date_desc")
                            Text("По дате ↑").tag("date_asc")
                            Text("Сумма ↓").tag("amount_desc")
                            Text("Сумма ↑").tag("amount_asc")
                            Text("Название A→Z").tag("name_asc")
                            Text("Название Z→A").tag("name_desc")
                            Text("Категория A→Z").tag("category_asc")
                            Text("Категория Z→A").tag("category_desc")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(filteredIncomes) { income in
                            NavigationLink(destination: EditIncomeView(income: income)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(income.name ?? "")
                                            .bold()
                                        Text("\(String(format: "%.2f", income.amount)) \(settings.selectedCurrency.sign)").foregroundColor(.green)
                                        HStack {
                                            Image(systemName: "\(findCategoryImage(for: income.category ?? ""))")
                                            Text(income.category!)
                                                .foregroundColor(.gray)
                                        }
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
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
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
                AddIncomeView()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private var filteredIncomes: [Income] {
        var list = income.map { $0 }

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

    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { income[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalIncomesToday() -> Double {
        var amountToday: Double = 0
        for item in income {
            if Calendar.current.isDateInToday(item.date!) {
                amountToday += item.amount
            }
        }
        return amountToday
    }
    
    private func findCategoryImage(for categoryName: String) -> String {
        for cat in categories {
            if cat.name == categoryName {
                return cat.image ?? "defaultImage" // Replace "defaultImage" with a default image name if needed
            }
        }
        return "defaultImage"
    }
}

#Preview {
    ListOfIncomes()
}
