//
//  Diagram.swift
//  CashFlow
//
//  Created by Паша on 4.04.24.
//

import SwiftUI
import Charts

struct ExpenseData {
    let name: String
    let amount: Int
    let category: String
}

struct Diagram: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default) private var expenses: FetchedResults<Expense>
    @FetchRequest(sortDescriptors: [], animation: .default) private var incomes: FetchedResults<Income>
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack {
                    VStack(alignment: .leading) { // Выравнивание содержимого по левому краю
                        NavigationLink("Расходы", destination: CategoriesExpenses(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil)))
                            .font(.title)
                            .fontWeight(.bold) // Установка жирного шрифта
                        ZStack(alignment: .center)  {
                            Chart(expenses.map { expense in
                                ExpenseData(name: expense.name ?? "", amount: Int(expense.amount), category: expense.category ?? "")
                            }, id: \.name) { expense in
                                if #available(iOS 17.0, *) {
                                    SectorMark(
                                        angle: .value ("Macros", expense.amount),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle (by: .value("Name", expense.category))
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            .frame(height: 300)
                        .chartXAxis(.hidden)
                            VStack {
                                Text("\(settings.selectedCurrency.sign)\(Int(totalExpenses()))")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                    }

                    VStack(alignment: .leading) { // Выравнивание содержимого по левому краю
                        Text("Доходы")
                            .font(.title)
                            .fontWeight(.bold) // Установка жирного шрифта
                        ZStack(alignment: .center)  {
                            Chart(incomes.map { income in
                                ExpenseData(name: income.name ?? "", amount: Int(income.amount), category: income.category ?? "")
                            }, id: \.name) { income in
                                if #available(iOS 17.0, *) {
                                    SectorMark(
                                        angle: .value ("Macros", income.amount),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle (by: .value("Name", income.category))
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            .frame(height: 300)
                            .chartXAxis(.hidden)
                            VStack {
                                Text("\(settings.selectedCurrency.sign)\(Int(totalIncomes()))")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            
                            
                            
                        }
                        

                        
                    }
                   
                    
                }
                .navigationTitle("Статистика")
                .padding()
            }
            
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }
    }
    
    private func totalExpenses() -> Double {
        var amount : Double = 0
        for item in expenses {
            amount += item.amount
        }
        
        return amount
    }
    
    private func totalIncomes() -> Double {
        var amount : Double = 0
        for item in incomes {
            amount += item.amount
        }
        
        return amount
    }
    
}


#Preview {
    Diagram()
}
