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
    @State private var amount: Double = 0
    
    
    var body: some View {
        Form {
            Section {
                TextField("Название", text: $name)
//                Picker("Категория", selection: $selectedCategory) {
//                    ForEach(categories, id: \.name) { category in
//                        Text(category.name).tag(category.name)
//                    }
//                }
                TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                HStack {
                    Spacer()
                    Button ("Сохранить"){
                        DataController().addIncome(name: name, amount: amount, context: managedObjContext)
                        dismiss()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AddIncomeView()
}
