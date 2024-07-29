import SwiftUI

struct ListOfExpensesCategories: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expenses: FetchedResults<Expense>
    var category: FetchedResults<Category>.Element

    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var selectedPeriod: Period = .today
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredExpenses: [Expense] = [] // Хранение фильтрованных расходов

    // Новая переменная состояния для строки поиска
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading) {
            period()
                .foregroundColor(.gray)
                .padding(.horizontal)
            Text("Категория - \(category.name ?? "")")
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Добавление строки поиска
            List {
                ForEach(filteredExpenses) { expense in
                    if expense.category == category.name {
                        NavigationLink(destination: EditExpenseView(expense: expense)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(expense.name ?? "")
                                        .bold()
                                    
                                    Text("\(String(format: "%.2f", expense.amount)) \(settings.selectedCurrency.sign)").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: expense.date ?? Date()))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) // Добавление свойства searchable
        }
        .navigationBarTitle("Расходы", displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddView.toggle()
                } label: {
                    Label("Добавить расход", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddExpenseView()
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
            loadUserDefaults()
            updateFilteredExpenses()
        }
        .onChange(of: searchText) { _ in
            updateFilteredExpenses()
        }
    }

    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }

    private func updateFilteredExpenses() {
        let (adjustedStartDate, adjustedEndDate) = startDate <= endDate ? (startDate, endDate) : (endDate, startDate)
        
        var expensesToFilter = Array(expenses)

        // Фильтрация расходов по строке поиска
        if !searchText.isEmpty {
            expensesToFilter = expensesToFilter.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        
        switch selectedPeriod {
        case .today:
            let startDate = Calendar.current.startOfDay(for: Date())
            let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            filteredExpenses = expensesToFilter.filter { ($0.date ?? Date()).isBetween(startDate, and: endDate) }
        case .allTime:
            filteredExpenses = expensesToFilter
        case .lastMonth:
            guard let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) else { return }
            let endOfMonth = Calendar.current.startOfDay(for: Date())
            let endOfMonth1 = Calendar.current.date(byAdding: .day, value: 1, to: endOfMonth)!
            filteredExpenses = expensesToFilter.filter { ($0.date ?? Date()).isBetween(startOfMonth, and: endOfMonth1) }
        case .custom:
            filteredExpenses = expensesToFilter.filter { ($0.date ?? Date()).isBetween(adjustedStartDate, and: adjustedEndDate) }
        }
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
    ListOfExpensesCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil).wrappedValue.first!)
}
