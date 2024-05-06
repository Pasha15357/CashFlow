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
        NavigationView {
            Form {
                Section(header: Text("Название напоминания")) {
                    TextField("Оплатить счета", text: $name)
                }
                Section(header: Text("Время напоминания")) {
                    DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .padding(.vertical)
                }
                
                
                Button("Сохранить") {
                    DataController().addReminder(name: name, date: date, context: managedObjectContext)
                    dismiss()
                }
                
                .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                
            }
            .navigationTitle("Новое напоминание")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        dismiss()
                    }) {
                        Text("Отменить")
                    }
                }
            }
        }
    }
    
    
}


#Preview {
    AddReminder()
}
