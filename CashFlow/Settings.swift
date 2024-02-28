//
//  Settings.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI

struct Settings: View {
    
    @State private var showingAddExpense = false
    
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    @State private var language = "Русский"
    static let languages = ["Русский", "English"]
    
    @State private var currency = "Доллар"
    static let currencies = ["Доллар", "Рубль"]
    
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
                            Text("Вход")
                                .font(.largeTitle)
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
                
                Picker("Валюта", selection: $currency) {
                    ForEach(Self.currencies, id: \.self) {
                        Text($0)
                    }
                }
                
                Section {
                    NavigationLink(destination: ApplePay()) {
                                        Text("Перейти на другой экран")
                                            .foregroundColor(.blue)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                }
                
                
            }
            .navigationBarTitle("Настройки")
            .sheet(isPresented: $showingAddExpense) {
                Registration()
            }
        }
        
    }
}

#Preview {
    Settings()
}


