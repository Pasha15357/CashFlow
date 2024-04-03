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
    @FetchRequest var category: FetchedResults<Category>
    
    @State private var name = ""
    @State private var amount: Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var selectedCategory: Category?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название расхода")) {
                    TextField("Леденец", text: $name)
                }
                Section(header: Text("Категория расхода"))  {
                    Menu {
                        ForEach(category, id: \.self) { cat in
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
                
                Section(header: Text("Сумма расхода")) {
                    TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Button("Сохранить") {
                    if let selectedCategory = selectedCategory {
                        DataController().addExpense(name: name, category: selectedCategory.name ?? "", amount: amount, context: managedObjContext)
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            .navigationTitle("Добавить расход")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        dismiss()
                    }) {
                        Text("Отменить")
                    }
                }
            }
            .onAppear {
                // Убеждаемся, что есть хотя бы одна категория в списке, прежде чем выбрать первую
                if let firstCategory = category.first {
                    selectedCategory = firstCategory
                }
            }
        }
        
    }
}



#Preview {
    AddExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
}
