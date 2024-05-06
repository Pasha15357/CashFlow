//
//  Settings.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import xlsxwriter


struct Settings: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var showingAddExpense = false
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    @State private var language = "Русский"
    static let languages = ["Русский", "English"]
    
    @State private var balanceInput = ""
    @State private var balance: Double = 0.0

    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var showingAddView = false
    
    struct Currency {
        var name: String
        var systemImageName: String
        var sign: String
    }
    
    static var selectedCurrencyIndex: Int = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex") // Объявляем selectedCurrencyIndex как static
        
        @State private var selectedCurrencyIndex = Self.selectedCurrencyIndex // Здесь используем static selectedCurrencyIndex
    let currencies: [Currency] = [
        Currency(name: "Доллар", systemImageName: "dollarsign.circle", sign: "$"),
        Currency(name: "Рубль", systemImageName: "rublesign.circle", sign: "₽"),
        Currency(name: "Евро", systemImageName: "eurosign.circle", sign: "€")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Профиль")) {
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        HStack (alignment: .center, spacing: 50){
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            if status{
                                Text("Паша")
                                    .font(.largeTitle)
                            }
                            else{
                                Text("Вход")
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                HStack {
                    Image("dark-theme")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    
                    Toggle("Тёмная тема", isOn: $isDarkModeOn)
                        .onChange(of: isDarkModeOn) { newValue in
                            if newValue {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                            } else {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                            }
                    }
                }
                HStack {
                    Image("language")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Picker("Язык", selection: $language) {
                        ForEach(Self.languages, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                HStack {
                    Image("currency")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Picker("Валюта", selection: $selectedCurrencyIndex) {
                        ForEach(0..<currencies.count) { index in
                            Label(currencies[index].name, systemImage: currencies[index].systemImageName)
                        }
                    }
                    .onChange(of: selectedCurrencyIndex) { newValue in
                        UserDefaults.standard.setValue(newValue, forKey: "selectedCurrencyIndex")
                }
                }
                
                
                NavigationLink(destination: EditBalance()) {
                    HStack {
                        Image("balance")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Баланс")
                        Spacer()
                        Text("\(settings.selectedCurrency.sign)\(balanceInput)")
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    balanceInput = String(DataController().getCurrentBalance(context: managedObjContext) ?? 0.0)
                }
                
                
                NavigationLink(destination: ListOfCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))) {
                    HStack {
                        Image("category")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Категории")
                    }
                }
                NavigationLink(destination: ListOfReminders()) {
                    Image("reminders")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("Напоминания")
                }
                
                Button(action: {
                    exportToExcel()
                }) {
                    HStack {
                        Image("export")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Экспорт")
                            .foregroundColor(.black)
                    }
                }

                
                Section {
                    Button (action : {
                        
                    }) {
                        Text("Выйти").foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
            .navigationBarTitle("Настройки")
            .sheet(isPresented: $showingAddExpense) {
                Registration1()
            }
        }
    }
    
    func exportToExcel() {
        let dataController = DataController() // Подставьте ваш класс управления данными
        let expenses = dataController.getAllExpenses() // Получите список расходов из вашего контроллера данных
        let incomes = dataController.getAllIncomes() // Получите список доходов из вашего контроллера данных
        
        let excelExporter = ExcelExporter()
        excelExporter.exportToExcel(expenses: expenses, incomes: incomes)
    }

    
}


#Preview {
    Settings()
}


