//
//  AddLent.swift
//  CashFlow
//
//  Created by Паша on 29.07.24.
//

import SwiftUI
import ContactsUI
import CoreData

struct AddLent: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var amountLent: Double = 0
    @State private var amountOwed: Double = 0
    @State private var dateTaken: Date = Date()
    @State private var dateDue = Date()
    @State private var contactName: String = ""
    @State private var contactIdentifier: String = ""
    @State private var isReminderSet = false
    
    @State private var showContactPicker = false
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Сколько взял")) {
                    TextField("100", value: $amountLent, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Сколько вернёт")) {
                    TextField("105", value: $amountOwed, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Даты")) {
                    DatePicker("Когда взял", selection: $dateTaken, displayedComponents: .date)

                    DatePicker("Когда вернёт", selection: $dateDue, displayedComponents: .date)

                    
                }
                
                Section(header: Text("Контакт")) {
                    TextField("Контакт", text: $contactName)
                        .disabled(true)
                    
                    Button("Выбрать контакт") {
                        showContactPicker = true
                    }
                    
                }
                Toggle(isOn: $isReminderSet) {
                    Text("Установить напоминание")
                }
                
            }
            .navigationBarTitle("Добавить долг", displayMode: .inline)
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                DataController().addLent(amountLent: amountLent, amountOwed: amountOwed, dateTaken: dateTaken, dateDue: dateDue, contactName: contactName, contactIdentifier: contactIdentifier, isReminderSet: isReminderSet, context: managedObjectContext)
                DataController().addExpense(name: "Дал в долг \(contactName)", category: "Долг", amount: amountLent, date: dateTaken, context: managedObjectContext)
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier)
            }
        }
    }
}


#Preview {
    AddLent()
}
