//
//  EditLent.swift
//  CashFlow
//
//  Created by Паша on 29.07.24.
//


import SwiftUI
import CoreData

struct EditLent: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    var lent : FetchedResults <Lent>.Element
    
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
                Section(header: Text("Сумма")) {
                    TextField("Сколько отдали", value: $amountLent, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    TextField("Сколько возвращают", value: $amountOwed, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Даты")) {
                    DatePicker("Когда взяли", selection: $dateTaken, displayedComponents: .date)

                    DatePicker("Когда вернут", selection: $dateDue, displayedComponents: .date)

                    
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
                amountLent = lent.amountLent
                amountOwed = lent.amountOwed
                dateTaken = lent.dateTaken!
                dateDue = lent.dateDue!
                contactName = lent.contactName!
                contactIdentifier = lent.contactIdentifier!
                isReminderSet = lent.isReminderSet
            }
            .navigationBarTitle("Редактировать долг", displayMode: .inline)
            .navigationBarItems(trailing: Button("Сохранить") {
                saveLent()
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView(contactName: $contactName, contactIdentifier: $contactIdentifier)
            }
        }
    }

    func saveLent() {
        

         lent.amountLent = amountLent
         lent.amountOwed = amountOwed
         lent.dateTaken = dateTaken
         lent.dateDue = dateDue
         lent.contactName = contactName
         lent.contactIdentifier = contactIdentifier
         lent.isReminderSet = isReminderSet

        if isReminderSet {
            addReminder(name: "Возврат долга: \(contactName)", date: dateDue, context: managedObjectContext)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }

    func addReminder(name: String, date: Date, context: NSManagedObjectContext) {
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


