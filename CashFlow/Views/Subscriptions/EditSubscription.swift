//
//  EditSubscription.swift
//  CashFlow
//
//  Created by Паша on 30.09.24.
//

import SwiftUI

struct Service: Identifiable {
    let id = UUID()
    var icon: String
    var name: String
}

struct EditSubscription: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var subscription: Subscription
    
    @State private var name: String
    @State private var service: String = ""
    @State private var serviceIcon: String = ""
    @State private var paymentFrequency: String
    @State private var duration: Int
    @State private var startDate: Date
    @State private var isReminderSet: Bool
    @State private var amount: Double // Сумма подписки

    
    init(subscription: Subscription) {
        self.subscription = subscription
        _name = State(initialValue: subscription.name ?? "")
        _service = State(initialValue: subscription.service ?? "Spotify")
        _serviceIcon = State(initialValue: subscription.serviceIcon ?? "spotify")
        _paymentFrequency = State(initialValue: subscription.paymentFrequency ?? "1 раз/месяц")
        _duration = State(initialValue: Int(subscription.duration))
        _startDate = State(initialValue: subscription.startDate ?? Date())
        _isReminderSet = State(initialValue: subscription.isReminderSet)
        _amount = State(initialValue: subscription.amount ) // Инициализация суммы подписки
    }
    
    
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
                .navigationBarTitle("Подписка")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Сохранить") {
                            DataController().editSubscription(subscription: subscription, name: name, service: service, serviceIcon: serviceIcon, paymentFrequency: paymentFrequency, duration: duration, startDate: startDate, isReminderSet: isReminderSet, context: managedObjectContext)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        
        
    }
    
    
}
