//
//  AddNotification.swift
//  CashFlow
//
//  Created by Паша on 2.05.24.
//

import SwiftUI
import CoreData

struct AddReminder: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var isNotificationScheduled = false

    var body: some View {
        VStack {
            TextField("Название напоминания", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .padding()

            Button(action: {
                DataController().addReminer(name: name, date: date, context: managedObjectContext)
                dismiss()
            }) {
                Text("Добавить напоминание")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Text(isNotificationScheduled ? "Напоминание запланировано" : "")
                .foregroundColor(.green)
        }
        .padding()
    }

    
}


#Preview {
    AddReminder()
}
