//
//  AddDebt.swift
//  CashFlow
//
//  Created by Паша on 3.07.24.
//

import SwiftUI
import ContactsUI
import CoreData

struct AddDebt: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var amountLent = Double()
    @State private var amountOwed = Double()
    @State private var dateTaken: Date = Date()
    @State private var dateDue = Date()
    @State private var contactName: String = ""
    @State private var contactIdentifier: String = ""
    @State private var contactPhoneNumber: String = ""
    @State private var isReminderSet = false
    
    @State private var showContactPicker = false
    
    var body: some View {
        NavigationStack {
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
                
            }
            .navigationBarTitle("Добавить долг", displayMode: .inline)
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                DataController().addDebt(amountLent: amountLent, amountOwed: amountOwed, dateTaken: dateTaken, dateDue: dateDue, contactName: contactName, contactIdentifier: contactIdentifier, contactPhoneNumber: contactPhoneNumber, isReminderSet: isReminderSet, context: managedObjectContext)
                DataController().addIncome(name: "Взяли в долг у \(contactName)", category: "Долг", amount: amountLent, date: dateTaken, context: managedObjectContext)
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier, contactPhoneNumber: $contactPhoneNumber)           
            }
        }
    }
    
    
}

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var contactName: String
    @Binding var contactIdentifier: String
    @Binding var contactPhoneNumber: String
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView
        
        init(parent: ContactPickerView) {
            self.parent = parent
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.contactName = "\(contact.givenName) \(contact.familyName)"
            parent.contactIdentifier = contact.identifier
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                parent.contactPhoneNumber = phoneNumber
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
}



#Preview {
    AddDebt()
}
