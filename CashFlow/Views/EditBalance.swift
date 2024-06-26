//
//  EditBalance.swift
//  CashFlow
//
//  Created by Паша on 8.04.24.
//

import SwiftUI

struct EditBalance: View {
    @Environment(\.managedObjectContext) var managedObjContext

    @Environment(\.dismiss) var dismiss

    @State private var balanceInput = ""
    @State private var balance: Double = 0.0
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings

    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Баланс (\(settings.selectedCurrency.sign))")) {
                    TextField("Введите ваш баланс", text: $balanceInput)
                }
                Section {
                    Button("Сохранить") {
                        if let newBalance = Double(balanceInput) {
                            saveNewBalance(newBalance)
                        }
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
        }
        .navigationBarTitle("Баланс")
        .onAppear {
            balanceInput = DataController().getCurrentBalanceString(context: managedObjContext)
        }
    }
    
    private func saveNewBalance(_ newBalance: Double) {
        // Создаем экземпляр DataController
        let dataController = DataController()
        // Вызываем метод saveNewBalance через экземпляр DataController, передавая новый баланс и объект контекста
        dataController.saveNewBalance(newBalance, newBalanceValue: newBalance, context: managedObjContext)
    }
}

#Preview {
    EditBalance()
}
