//
//  EditIncomeView.swift
//  CashFlow
//
//  Created by Паша on 29.02.24.
//

import SwiftUI

struct EditIncomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest var category: FetchedResults<Category>
    
    var income : FetchedResults<Income>.Element
    
    @State private var name = ""
    @State private var amount : Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var selectedCategory: Category?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Название дохода")) {
                    TextField("\(income.name!)", text: $name)
                        .onAppear {
                            name = income.name!
                            amount = income.amount
                        }
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
                        DataController().editIncome(income: income, category: selectedCategory.name ?? "", name: name, amount: amount, context: managedObjContext)
                        dismiss()
                        
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            
            .onAppear {
                // Убеждаемся, что есть хотя бы одна категория в списке, прежде чем выбрать первую
                if let firstCategory = category.first {
                    selectedCategory = firstCategory
                }
            }
        }
        .navigationTitle("Доход")
    }
}

