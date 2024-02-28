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
    
    var income : FetchedResults<Income>.Element
    
    @State private var name = ""
    @State private var amount : Double = 0
    
    var body: some View {
        Form {
            Section {
                TextField("\(income.name!)", text: $name)
                    .onAppear {
                        name = income.name!
                        amount = income.amount
                    }
                TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                HStack {
                    Spacer()
                    
                    Button ("Сохранить"){
                        DataController().editIncome(income: income, name: name, amount: amount, context: managedObjContext)
                        dismiss()
                    }
                
                    Spacer()
                }
            }
        }
    }
}

