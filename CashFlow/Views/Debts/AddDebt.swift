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
    @State private var amount: String = ""
    @State private var dateTaken: Date = Date()
    @State private var dateDue: Date = Date()
    @State private var contactName: String = ""
    @State private var contactIdentifier: String = ""
    @State private var isReminderSet: Bool = false
    @State private var isDebtOwedToMe: Bool = true
    @State private var showContactPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Детали долга")) {
                    TextField("Сумма", text: $amount)
                        .keyboardType(.decimalPad)

                    DatePicker("Дата взятия", selection: $dateTaken, displayedComponents: .date)

                    DatePicker("Дата возврата", selection: $dateDue, displayedComponents: .date)

                    Toggle(isOn: $isReminderSet) {
                        Text("Установить напоминание")
                    }
                }

                Section(header: Text("Контакт")) {
                    TextField("Контакт", text: $contactName)
                        .disabled(true)

                    Button("Выбрать контакт") {
                        showContactPicker = true
                    }
                }

                Section {
                    Picker("Тип долга", selection: $isDebtOwedToMe) {
                        Text("Мне должны").tag(true)
                        Text("Я должен").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Добавить долг", displayMode: .inline)
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                saveDebt()
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier)
            }
        }
    }

    private func saveDebt() {
        guard let amountDouble = Double(amount) else { return }

        let newDebt = Debt(context: managedObjectContext)
        newDebt.id = UUID()
        newDebt.amount = amountDouble
        newDebt.dateTaken = dateTaken
        newDebt.dateDue = dateDue
        newDebt.contactName = contactName
        newDebt.contactIdentifier = contactIdentifier
        newDebt.isReminderSet = isReminderSet
        newDebt.isDebtOwedToMe = isDebtOwedToMe

        if isReminderSet {
            addReminder(name: "Возврат долга: \(contactName)", date: dateDue, context: managedObjectContext)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }

    private func addReminder(name: String, date: Date, context: NSManagedObjectContext) {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.name = name
        reminder.date = date

        do {
            try context.save()
            scheduleNotification(for: reminder)
        } catch {
            print("Ошибка сохранения напоминания: \(error.localizedDescription)")
        }
    }

    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = reminder.name ?? ""
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка планирования уведомления: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    AddDebt()
}
