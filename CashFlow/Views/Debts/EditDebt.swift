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
    @State private var contactPhoneNumber: String = ""
    @State private var isReminderSet = false
    @State private var showContactPicker = false

    

    var body: some View {
        NavigationStack {
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
                        TextField("Имя человека", text: $contactName)
                        
                        
                        TextField("Номер телефона", text: $contactPhoneNumber)
                        
                        Button("Выбрать контакт") {
                            showContactPicker = true
                        }
                        
                    }
                    Toggle(isOn: $isReminderSet) {
                        Text("Установить напоминание")
                    }
                    
                    Section {
                        HStack {
                            Text("                         ")
                            Button("Сохранить") {
                                DataController().editDebt(debt: debt, amountLent: amountLent, amountOwed: amountOwed, dateTaken: dateTaken, dateDue: dateDue, contactName: contactName, contactIdentifier: contactIdentifier, contactPhoneNumber: contactPhoneNumber, isReminderSet: isReminderSet, context: managedObjectContext)
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                        }
                        Button("Удалить") {
                            // Удаляем выбранный долг из базы данных
                            managedObjectContext.delete(debt)
                            
                            // Сохраняем изменения
                            do {
                                try managedObjectContext.save()
                            } catch {
                                print("Ошибка при сохранении контекста: \(error)")
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                    }
                    
                    
                }
                .onAppear {
                    amountLent = debt.amountLent
                    amountOwed = debt.amountOwed
                    dateTaken = debt.dateTaken!
                    dateDue = debt.dateDue!
                    contactName = debt.contactName!
                    contactIdentifier = debt.contactIdentifier!
                    contactPhoneNumber = debt.contactPhoneNumber ?? ""
                    isReminderSet = debt.isReminderSet
                }
                .navigationBarTitle("Редактировать долг", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Отменить")
                        }
                    }
                }
                .sheet(isPresented: $showContactPicker) {
                    ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier, contactPhoneNumber: $contactPhoneNumber)
                }
            }
        }
    }
}







