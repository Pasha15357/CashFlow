//
//  AddSubscription.swift
//  CashFlow
//
//  Created by Паша on 30.09.24.
//

import SwiftUI
import CoreData

struct AddSubscriptionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var service: String = "Spotify"
    @State private var serviceIcon: String = ""
    @State private var paymentFrequency: String = "1 раз/месяц"
    @State private var duration: Int = 1
    @State private var startDate = Date()
    @State private var isReminderSet = false
    @State private var amount: Double = 0

    @State private var services = [
        Service(icon: "spotify", name: "Spotify"),
        Service(icon: "apple", name: "Apple"),
        Service(icon: "youtube", name: "YouTube"),
        Service(icon: "netflix", name: "Netflix"),
        Service(icon: "microsoft", name: "Microsoft")
    ]
    let paymentFrequencies = ["1 раз/месяц", "2 раза/месяц", "1 раз/неделю"]
    let durations = [1, 3, 6, 12, 24]
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Название"))  {
                        TextField("Название", text: $name)
                        
                    }
                    Section(header: Text("Цена"))  {
                        
                        TextField("Цена", value: $amount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("Детали"))  {
                        HStack {
                            Text("Выберите сервис")
                            Spacer()
                            Menu {
                                ForEach(services, id: \.id) { service in
                                    Button(action: {
                                        self.service = service.name
                                        self.serviceIcon = service.icon
                                    }) {
                                        HStack {
                                            Image(service.icon)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                            Text(service.name)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    if !serviceIcon.isEmpty {
                                        Image(serviceIcon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                    }
                                    Text(service.isEmpty ? "Выберите сервис" : service)
                                }
                            }
                        }
                        Picker("Частота платежа", selection: $paymentFrequency) {
                            ForEach(paymentFrequencies, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("Длительность (месяцев)", selection: $duration) {
                            ForEach(durations, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        
                        DatePicker("Начало подписки", selection: $startDate, displayedComponents: .date)
                    }
                    Toggle(isOn: $isReminderSet) {
                        Text("Напоминание")
                    }
                    
                }
                
            }
            .navigationBarTitle("Добавить подписку")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        saveSubscription()
                        presentationMode.wrappedValue.dismiss()
                        automateSubscriptionPayments(context: managedObjectContext)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
    }
    
    private func saveSubscription() {
        let newSubscription = Subscription(context: managedObjectContext)
        newSubscription.name = name
        newSubscription.service = service
        newSubscription.paymentFrequency = paymentFrequency
        newSubscription.duration = Int16(duration)
        newSubscription.startDate = startDate
        newSubscription.isReminderSet = isReminderSet
        newSubscription.nextPaymentDate = startDate
        newSubscription.amount = amount


        if isReminderSet {
            addReminder(name: "Subscription for \(service)", date: startDate, context: managedObjectContext)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save subscription: \(error.localizedDescription)")
        }
    }
    
    private func addReminder(name: String, date: Date, context: NSManagedObjectContext) {
        let reminder = Reminder(context: context)
        reminder.name = name
        reminder.date = date
        
        do {
            try context.save()
            scheduleNotification(for: reminder)
        } catch {
            print("Failed to save reminder: \(error.localizedDescription)")
        }
    }
    
    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.name ?? ""
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
    
    func automateSubscriptionPayments(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()

        do {
            let subscriptions = try context.fetch(fetchRequest)
            let currentDate = Date()

            for subscription in subscriptions {
                guard let nextPaymentDate = subscription.nextPaymentDate else { continue }
                
                if currentDate >= nextPaymentDate {
                    let amount = subscription.amount

                    // Вычитаем сумму подписки из баланса
                    deductAmount(amount, context: context)

                    // Обновляем дату следующего платежа на основе частоты
                    switch subscription.paymentFrequency {
                    case "1 раз/месяц":
                        subscription.nextPaymentDate = Calendar.current.date(byAdding: .month, value: 1, to: nextPaymentDate)
                        print("1 раз/месяц")
                        
                    case "1 раз/неделю":
                        subscription.nextPaymentDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: nextPaymentDate)
                        print("1 раз/неделю")
                    case "2 раза/месяц":
                        subscription.nextPaymentDate = Calendar.current.date(byAdding: .day, value: 15, to: nextPaymentDate)
                        print("2 раза/месяц")
                    default:
                        break
                    }
                    print(subscription.nextPaymentDate!)
                    try context.save()  // Сохраняем изменения
                }
            }
        } catch {
            print("Ошибка при получении подписок: \(error)")
        }
    }


    func deductAmount(_ amount: Double, context: NSManagedObjectContext) {
        guard let currentBalance = DataController().getCurrentBalance(context: context) else { return }
        let newBalance = currentBalance - amount
        DataController().saveNewBalance(newBalance, newBalanceValue: newBalance, context: context)
    }



}


#Preview {
    AddSubscriptionView()
}
