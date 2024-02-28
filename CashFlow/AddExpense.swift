//
//  AddExpense.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Личный"
    @State private var amount = ""
    @State private var selectedCategory: String = ""
    
    static let types = ["Личный", "Рабочий"]
    
    @State var categories: [Category] = [
            Category(name: "Бензин", image: "drop.fill"),
            Category(name: "Еда", image: "fork.knife"),
            Category(name: "Спорт", image: "figure.run.circle.fill")
        ]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Название", text: $name)
                Picker("Тип", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Категория", selection: $selectedCategory) {
                    ForEach(categories, id: \.name) { category in
                        Text(category.name).tag(category.name)
                    }
                }
                TextField("Стоимость", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Добавить")
            .navigationBarItems(trailing: Button("Сохранить") {
                if let actualAmount = Int64(self.amount) {
                    self.expenses.saveExpense(name: self.name, type: self.type, amount: Int64(Int(actualAmount)), category: self.selectedCategory)
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
        
    }
}




struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(expenses: Expenses())
    }
}
