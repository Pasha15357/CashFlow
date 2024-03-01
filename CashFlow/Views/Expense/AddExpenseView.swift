//
//  AddExpenseView.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount: Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var categoryNames: [String] = [] // Массив имен категорий
    @State private var selectedCategory: String = ""
    
    init() {
        // Заполнение массива имен категорий из FetchedResults<Category>
        _categoryNames = State(initialValue: categories.map { $0.name ?? "" })
        
        // Печать массива имен категорий для отладки
        print("Category names:", categoryNames)
    }

    
    var body: some View {
        Form {
            Section {
                TextField("Название", text: $name)
                Picker("Выберите категорию", selection: $selectedCategory) {
                    ForEach(categoryNames, id: \.self) { categoryName in
                        Text(categoryName)
                    }
                }
                
                TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                Button("Сохранить") {
                    // Ваш код сохранения
                }
            }
        }
    }
}









#Preview {
    AddExpenseView()
}
