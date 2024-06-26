//
//  ListOfNotifications.swift
//  CashFlow
//
//  Created by Паша on 2.05.24.
//

import SwiftUI
import CoreData




struct ListOfReminders: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminder: FetchedResults<Reminder>
    
    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var reminders = [Reminder]()
    @State private var reminderTitle = ""
    @State private var reminderDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(reminder) { reminder in
                    NavigationLink(destination: EditReminder(reminder: reminder)) {
                        HStack {
                            VStack (alignment: .leading, spacing: 6) {
                                Text(reminder.name ?? "")
                                    .bold()
                                Text(dateToString(reminder.date!))
                                    .bold()
                                
                            }
                            
                            
                        }
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Напоминания")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddView.toggle()
                } label: {
                    Label("Добавить расход", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddReminder()
        }
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
            
            // Загрузка существующих напоминаний
            loadReminders()
        }
        
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { reminder[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Задайте желаемый формат даты и времени
        return dateFormatter.string(from: date)
    }
    
    
    private func loadReminders() {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.date, ascending: false)]
        
        do {
            reminders = try managedObjContext.fetch(request)
        } catch {
            print("Error loading reminders: \(error.localizedDescription)")
        }
    }
    
    
    private func deleteReminder(at offsets: IndexSet) {
        withAnimation {
            offsets.map { reminder[$0] }.forEach(managedObjContext.delete)

            
            DataController().save(context: managedObjContext)
        }
    }
    
}

#Preview {
    ListOfReminders()
}
