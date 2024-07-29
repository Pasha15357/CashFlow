//
//  Diagram.swift
//  CashFlow
//
//  Created by Паша on 4.04.24.
//

// Diagram.swift
import SwiftUI
import Charts
import Foundation

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        let (startDate, endDate) = date1 <= date2 ? (date1, date2) : (date2, date1)
        return (startDate...endDate).contains(self)
    }
}
// Определение типа Period
enum Period: String, CaseIterable {
    case today = "Сегодня"
    case lastMonth = "Месяц"
    case allTime = "Весь период"
    case custom = "Пользовательский"
}

extension UserDefaults {
    private enum Keys {
        static let selectedPeriod = "selectedPeriod"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let incomeSelectedPeriod = "incomeSelectedPeriod"
        static let incomeStartDate = "incomeStartDate"
        static let incomeEndDate = "incomeEndDate"
    }
    
    func saveSelectedPeriod(_ period: Period) {
        set(period.rawValue, forKey: Keys.selectedPeriod)
    }
    
    func loadSelectedPeriod() -> Period {
        let rawValue = string(forKey: Keys.selectedPeriod) ?? Period.today.rawValue
        return Period(rawValue: rawValue) ?? .today
    }
    
    func saveStartDate(_ date: Date) {
        set(date, forKey: Keys.startDate)
    }
    
    func loadStartDate() -> Date {
        return object(forKey: Keys.startDate) as? Date ?? Date()
    }
    
    func saveEndDate(_ date: Date) {
        set(date, forKey: Keys.endDate)
    }
    
    func loadEndDate() -> Date {
        return object(forKey: Keys.endDate) as? Date ?? Date()
    }
    
    func saveIncomeSelectedPeriod(_ period: Period) {
        set(period.rawValue, forKey: Keys.incomeSelectedPeriod)
    }
    
    func loadIncomeSelectedPeriod() -> Period {
        let rawValue = string(forKey: Keys.incomeSelectedPeriod) ?? Period.today.rawValue
        return Period(rawValue: rawValue) ?? .today
    }
    
    func saveIncomeStartDate(_ date: Date) {
        set(date, forKey: Keys.incomeStartDate)
    }
    
    func loadIncomeStartDate() -> Date {
        return object(forKey: Keys.incomeStartDate) as? Date ?? Date()
    }
    
    func saveIncomeEndDate(_ date: Date) {
        set(date, forKey: Keys.incomeEndDate)
    }
    
    func loadIncomeEndDate() -> Date {
        return object(forKey: Keys.incomeEndDate) as? Date ?? Date()
    }
}

struct ExpenseData {
    let name: String
    let amount: Int
    let category: String
}

struct Diagram: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default) private var expenses: FetchedResults<Expense>
    @FetchRequest(sortDescriptors: [], animation: .default) private var incomes: FetchedResults<Income>
    
    @StateObject private var settings = Settings1() // Перенос инициализации сюда

    @State private var selectedPeriod: Period = .today
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredExpenses: [Expense] = []
    
    @State private var incomeSelectedPeriod: Period = .today
    @State private var incomeStartDate = Date()
    @State private var incomeEndDate = Date()
    @State private var filteredIncomes: [Income] = []
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Расходы
                    HStack {
                        Text("Расходы -")
                            .font(.title)
                            .bold()
                        Text("\(Int(totalExpenses())) \(settings.selectedCurrency.sign)")
                            .foregroundColor(.red)
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Выравнивание текста по левому краю

                    // Панель с переключателями для расходов
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                    .onChange(of: selectedPeriod) { newValue in
                        UserDefaults.standard.saveSelectedPeriod(newValue)
                        updateFilteredExpenses()
                    }
                    switch selectedPeriod {
                    case .today:
                        dateForToday()
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .lastMonth:
                        dateForMonth()
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .allTime:
                        Text("Весь период")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .custom:
                        HStack(alignment: .center) {
                            DatePicker("", selection: $startDate, displayedComponents: .date)
                                .onChange(of: startDate) { newValue in
                                    UserDefaults.standard.saveStartDate(newValue)
                                    updateFilteredExpenses()
                                }
                                .labelsHidden() // Убирает текстовую метку над DatePicker
                            Text("—")
                                .bold()
                            DatePicker("", selection: $endDate, displayedComponents: .date)
                                .onChange(of: endDate) { newValue in
                                    UserDefaults.standard.saveEndDate(newValue)
                                    updateFilteredExpenses()
                                }
                                .labelsHidden() // Убирает текстовую метку над DatePicker
                        }
                    }
                    VStack(alignment: .leading) { // Выравнивание содержимого по левому краю
                        NavigationLink(destination: CategoriesExpenses()) {
                            VStack {
                                Chart(filteredExpenses.map { expense in
                                    ExpenseData(name: expense.name ?? "", amount: Int(expense.amount), category: expense.category ?? "")
                                }, id: \.name) { expense in
                                    if #available(iOS 17.0, *) {
                                        SectorMark(
                                            angle: .value("Macros", expense.amount),
                                            innerRadius: .ratio(0.618),
                                            angularInset: 1.5
                                        )
                                        .cornerRadius(4)
                                        .foregroundStyle(by: .value("Name", expense.category))
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                                .frame(height: 300)
                                .chartXAxis {
                                    AxisMarks(position: .bottom, values: .stride(by: 1)) { value in
                                        AxisValueLabel()
                                    }
                                }
                                .chartXAxis(.hidden)
                            }
                        }
                        .font(.title)
                        .fontWeight(.bold) // Установка жирного шрифта
                    }

                    // Доходы
                    HStack {
                        Text("Доходы -")
                            .font(.title)
                            .bold()
                        Text("\(Int(totalIncomes())) \(settings.selectedCurrency.sign)")
                            .foregroundColor(.green)
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Выравнивание текста по левому краю
                    .padding(.top, 20)

                    // Панель с переключателями для доходов
                    Picker("Income Period", selection: $incomeSelectedPeriod) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                    .onChange(of: incomeSelectedPeriod) { newValue in
                        UserDefaults.standard.saveIncomeSelectedPeriod(newValue)
                        updateFilteredIncomes()
                    }
                    switch incomeSelectedPeriod {
                    case .today:
                        dateForToday()
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .lastMonth:
                        dateForMonth()
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .allTime:
                        Text("Весь период")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 9)
                    case .custom:
                        HStack(alignment: .center) {
                            DatePicker("", selection: $incomeStartDate, displayedComponents: .date)
                                .onChange(of: incomeStartDate) { newValue in
                                    UserDefaults.standard.saveIncomeStartDate(newValue)
                                    updateFilteredIncomes()
                                }
                                .labelsHidden() // Убирает текстовую метку над DatePicker
                            Text("—")
                                .bold()
                            DatePicker("", selection: $incomeEndDate, displayedComponents: .date)
                                .onChange(of: incomeEndDate) { newValue in
                                    UserDefaults.standard.saveIncomeEndDate(newValue)
                                    updateFilteredIncomes()
                                }
                                .labelsHidden() // Убирает текстовую метку над DatePicker
                        }
                    }
                    VStack(alignment: .leading) { // Выравнивание содержимого по левому краю
                        NavigationLink(destination: CategoriesIncomes()) {
                            VStack {
                                Chart(filteredIncomes.map { income in
                                    ExpenseData(name: income.name ?? "", amount: Int(income.amount), category: income.category ?? "")
                                }, id: \.name) { income in
                                    if #available(iOS 17.0, *) {
                                        SectorMark(
                                            angle: .value("Macros", income.amount),
                                            innerRadius: .ratio(0.618),
                                            angularInset: 1.5
                                        )
                                        .cornerRadius(4)
                                        .foregroundStyle(by: .value("Name", income.category))
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                                .frame(height: 300)
                                .chartXAxis {
                                    AxisMarks(position: .bottom, values: .stride(by: 1)) { value in
                                        AxisValueLabel()
                                    }
                                }
                                .chartXAxis(.hidden)
                            }
                        }
                        .font(.title)
                        .fontWeight(.bold) // Установка жирного шрифта
                    }
                    
                }
                .navigationBarTitle("Статистика", displayMode: .inline)
                .padding()
            }
        }
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
            
            // Загружаем данные из UserDefaults для расходов
            selectedPeriod = UserDefaults.standard.loadSelectedPeriod()
            startDate = UserDefaults.standard.loadStartDate()
            endDate = UserDefaults.standard.loadEndDate()
            
            // Загружаем данные из UserDefaults для доходов
            incomeSelectedPeriod = UserDefaults.standard.loadIncomeSelectedPeriod()
            incomeStartDate = UserDefaults.standard.loadIncomeStartDate()
            incomeEndDate = UserDefaults.standard.loadIncomeEndDate()
            
            updateFilteredExpenses()
            updateFilteredIncomes()
        }
    }
    
    private func totalExpenses() -> Double {
        var amount: Double = 0
        for item in filteredExpenses {
            amount += item.amount
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
    
    func dateForToday() -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate = dateFormatter.string(from: Date())
        return Text(formattedDate)
    }

    func dateForMonth() -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let formattedDate = dateFormatter.string(from: Date())
        let capitalizedMonth = formattedDate.capitalized
        return Text(capitalizedMonth)
    }
    
    private func updateFilteredExpenses() {
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
            filteredExpenses = expenses.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        }
    }

    private func updateFilteredIncomes() {
        switch incomeSelectedPeriod {
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
            filteredIncomes = incomes.filter { ($0.date ?? Date()).isBetween(incomeStartDate, and: incomeEndDate) }
        }
    }
}

#Preview {
    Diagram()
}
