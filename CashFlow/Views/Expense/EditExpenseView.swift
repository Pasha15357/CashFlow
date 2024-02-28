//
//  EditExpenseView.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var expense : FetchedResults<Expense>.Element
    
    @State private var name = ""
    @State private var amount : Double = 0
    
    var body: some View {
        Form {
            Section {
                TextField("\(expense.name!)", text: $name)
                    .onAppear {
                        name = expense.name!
                        amount = expense.amount
                    }
                TextField("Стоимость", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                
                HStack {
                    Spacer()
                    
                    Button ("Сохранить"){
                        DataController().editExpense(expense: expense, name: name, amount: amount, context: managedObjContext)
                        dismiss()
                    }
                
                    Spacer()
                }
            }
        }
    }
}


