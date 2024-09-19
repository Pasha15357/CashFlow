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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var reminders: FetchedResults<Reminder>
    
    @State private var showingAddView = false
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
//    @State private var reminders = [Reminder]()
    @State private var reminderTitle = ""
    @State private var reminderDate = Date()
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                Text("Список напоминаний")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(filteredReminders) { reminder in
                        NavigationLink(destination: EditReminder(reminder: reminder)) {
                            HStack {
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(reminder.name ?? "")
                                        .bold()
                                    Text(dateToString(reminder.date!))
                                        
                                    
                                }
                                
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
                
            }
        }
        .navigationViewStyle(.stack)
        
    }
    
    private var filteredReminders: [Reminder] {
        if searchText.isEmpty {
            return reminders.map { $0 }
        } else {
            return reminders.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { reminders[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Задайте желаемый формат даты и времени
        return dateFormatter.string(from: date)
    }
    

    
    
    private func deleteReminder(at offsets: IndexSet) {
        withAnimation {
            offsets.map { reminders[$0] }.forEach(managedObjContext.delete)

            
            DataController().save(context: managedObjContext)
        }
    }
    
}

#Preview {
    ListOfReminders()
}
