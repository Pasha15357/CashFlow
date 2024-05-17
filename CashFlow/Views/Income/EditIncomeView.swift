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
    @State private var date = Date()

    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var selectedCategory: Category?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Название дохода")) {
                    TextField("\(income.name!)", text: $name)
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
                
                Section(header: Text("Дата расхода")) {
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding(.vertical)
                }
                
                Button("Сохранить") {
                    if let selectedCategory = selectedCategory {
                        DataController().editIncome(income: income, category: selectedCategory.name ?? "", name: name, amount: amount, date: date, context: managedObjContext)
                        dismiss()
                        
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            
            .onAppear {
                name = income.name!
                amount = income.amount
                date = income.date!
                for cat in category {
                    if income.category == cat.name {
                        selectedCategory = cat
                    }
                }
            }
        }
        .navigationTitle("Доход")
    }
}

