//
//  EditDebt.swift
//  CashFlow
//
//  Created by Паша on 3.07.24.
//

import SwiftUI
import CoreData

struct EditDebt: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var debt : FetchedResults <Debt>.Element
    
    @State private var amountLent: Double = 0
    @State private var amountOwed: Double = 0
    @State private var dateTaken: Date = Date()
    @State private var dateDue = Date()
    @State private var contactName: String = ""
    @State private var contactIdentifier: String = ""
    @State private var isReminderSet = false
    @State private var showContactPicker = false

    

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Сколько взяли")) {
                    TextField("100", value: $amountLent, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Сколько вернёте")) {
                    TextField("105", value: $amountOwed, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Даты")) {
                    DatePicker("Когда взяли", selection: $dateTaken, displayedComponents: .date)

                    DatePicker("Когда вернёте", selection: $dateDue, displayedComponents: .date)

                    
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
            .onAppear {
                amountLent = debt.amountLent
                amountOwed = debt.amountOwed
                dateTaken = debt.dateTaken!
                dateDue = debt.dateDue!
                contactName = debt.contactName!
                contactIdentifier = debt.contactIdentifier!
                isReminderSet = debt.isReminderSet
            }
            .navigationBarTitle("Редактировать долг", displayMode: .inline)
            .navigationBarItems(trailing: Button("Сохранить") {
                saveDebt()
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier)
            }
        }
    }

    func saveDebt() {
        debt.amountLent = amountLent
        debt.amountOwed = amountOwed
        debt.dateTaken = dateTaken
        debt.dateDue = dateDue
        debt.contactName = contactName
        debt.contactIdentifier = contactIdentifier
        debt.isReminderSet = isReminderSet

        if isReminderSet {
            DataController().addReminder(name: "Возврат долга: \(contactName)", date: dateDue, context: managedObjectContext)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }

    
}


