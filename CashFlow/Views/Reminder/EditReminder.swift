//
//  EditReminder.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct EditReminder: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var reminder : FetchedResults<Reminder>.Element

    
    @State private var name = ""
    @State private var date = Date()
    
    var body: some View {
            Form {
                Section(header: Text("Название напоминания")) {
                    TextField("Оплатить счета", text: $name)
                        .onAppear {
                            name = reminder.name!
                            date = reminder.date!
                            //                            selectedCategory = expense.category
                        }
                }
                Section(header: Text("Время напоминания")) {
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding(.vertical)
                }
                
                
                Button("Сохранить") {
                    DataController().editReminder(reminder: reminder, name: name, date: date, context: managedObjectContext)
                    dismiss()
                }
                
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            .navigationTitle("Напоминание")
    }
}

