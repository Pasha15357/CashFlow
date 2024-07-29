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
            .navigationBarTitle("Добавить долг", displayMode: .inline)
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                DataController().addDebt(amountLent: amountLent, amountOwed: amountOwed, dateTaken: dateTaken, dateDue: dateDue, contactName: contactName, contactIdentifier: contactIdentifier, isReminderSet: isReminderSet, context: managedObjectContext)
                DataController().addIncome(name: "Взял в долг у \(contactName)", category: "Долг", amount: amountLent, date: dateTaken, context: managedObjectContext)
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier)
            }
        }
    }

    
}

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var contactName: String
    @Binding var contactIdentifier: String
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView

        init(parent: ContactPickerView) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.contactName = "\(contact.givenName) \(contact.familyName)"
            parent.contactIdentifier = contact.identifier
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
