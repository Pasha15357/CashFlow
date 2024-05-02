//
//  Settings.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation



struct Settings: View {
    
    @State private var showingAddExpense = false
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    @State private var language = "Русский"
    static let languages = ["Русский", "English"]
    
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
                Toggle("Тёмная тема", isOn: $isDarkModeOn)
                    .onChange(of: isDarkModeOn) { newValue in
                        if newValue {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                        } else {
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                        }
                    }
                Picker("Язык", selection: $language) {
                    ForEach(Self.languages, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Валюта", selection: $selectedCurrencyIndex) {
                    ForEach(0..<currencies.count) { index in
                        Label(currencies[index].name, systemImage: currencies[index].systemImageName)
                    }
                }
                .onChange(of: selectedCurrencyIndex) { newValue in
                    UserDefaults.standard.setValue(newValue, forKey: "selectedCurrencyIndex")
                }
                
                
                NavigationLink("Изменить баланс", destination: EditBalance())
                
                
                NavigationLink("Категории", destination: ListOfCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil)))
                NavigationLink("Напоминания", destination: ListOfReminders())

                
                Section {
                    Button (action : {
                        
                    }) {
                        Text("Выйти").foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                }
            }
            .navigationBarTitle("Настройки")
            .sheet(isPresented: $showingAddExpense) {
                Registration1()
            }
        }
    }
}


#Preview {
    Settings()
}


