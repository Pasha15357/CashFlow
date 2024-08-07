//
//  AddIncomeView.swift
//  CashFlow
//
//  Created by Паша on 29.02.24.
//

import SwiftUI

struct AddIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = Double()
    @State private var date = Date()

    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var selectedCategory: Category?
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название дохода")) {
                    TextField("Зарплата", text: $name)
                }
                Section(header: Text("Категория дохода"))  {
                    Menu {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: {
                                selectedCategory = cat
                            }) {
                                Image(systemName: "\(cat.image!)")
                                Text(cat.name ?? "")
                            }
                        }
                    } label: {
                        Image(systemName: "\(selectedCategory?.image ?? "")")
                        Text(selectedCategory?.name ?? "Выберите категорию")
                    }
                }
                
                Section(header: Text("Сумма дохода (\(settings.selectedCurrency.sign))")) {
                    TextField("Стоимость", value: $amount, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Дата расхода")) {
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        
                }
                
                Button("Сохранить") {
                    if let selectedCategory = selectedCategory {
                        let expenseAmount = amount
                        DataController().addIncome(name: name, category: selectedCategory.name ?? "", amount: amount, date: date, context: managedObjContext)
                        
                        // Получаем текущий баланс
                        guard let currentBalance = DataController().getCurrentBalance(context: managedObjContext) else { return }

                        // Вычитаем сумму расхода из текущего баланса
                        let newBalance = currentBalance + expenseAmount
                        
                        // Сохраняем измененный баланс обратно в Core Data
                        DataController().saveNewBalance(newBalance, newBalanceValue: newBalance, context: managedObjContext)

                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            .navigationTitle("Добавить доход")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        dismiss()
                    }) {
                        Text("Отменить")
                    }
                }
            }
            
        }
    }
}

#Preview {
    AddIncomeView()
}
