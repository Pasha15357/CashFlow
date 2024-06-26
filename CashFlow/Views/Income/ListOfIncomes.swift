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

    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalIncomesToday())) \(settings.selectedCurrency.sign) за сегодня")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(filteredIncomes) { income in
                        NavigationLink(destination: EditIncomeView(income: income)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(income.name!)
                                        .bold()
                                    Text("\(Int(income.amount)) \(settings.selectedCurrency.sign)").foregroundColor(.green)
                                    HStack {
                                        Image(systemName: "\(findCategoryImage(for: income.category ?? ""))")
                                        Text(income.category ?? "")
                                            .bold()
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
                AddIncomeView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private var filteredIncomes: [Income] {
        if searchText.isEmpty {
            return income.map { $0 }
        } else {
            return income.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
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
