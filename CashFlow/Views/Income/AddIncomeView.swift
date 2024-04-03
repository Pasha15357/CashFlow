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
    @FetchRequest var category: FetchedResults<Category>
    
    @State private var name = ""
    @State private var amount: Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название дохода")) {
                    TextField("Зарплата", text: $name)
                }
                Section(header: Text("Категория дохода"))  {
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
                
                Section(header: Text("Сумма дохода")) {
                    TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Button("Сохранить") {
                    if let selectedCategory = selectedCategory {
                        DataController().addIncome(name: name, category: selectedCategory.name ?? "", amount: amount, context: managedObjContext)
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
    AddIncomeView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
}
