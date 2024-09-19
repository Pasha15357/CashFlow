//
//  DataController.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import Foundation
import SwiftUI
import CoreData


class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var settings = Settings1() // Создаем экземпляр Settings


    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Не удалось загрузить данные \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Данные сохранены")
        } catch {
            print("Данные не могут быть сохранены")
        }
    }
    
    func addExpense (name:String, category:String, amount: Double, date: Date, context: NSManagedObjectContext) {
        let expense = Expense(context: context)
        expense.id = UUID()
        expense.date = Date()
        expense.name = name
        expense.amount = amount
        expense.category = category
        expense.date = date
        
        save(context: context)
    }
    
    func editExpense(expense: Expense, category:String, name : String, amount : Double, date: Date, context: NSManagedObjectContext) {
        expense.date = Date()
        expense.name = name
        expense.amount = amount
        expense.category = category
        expense.date = date

        save(context: context)
    }
    
    func addIncome (name:String, category:String, amount: Double, date: Date, context: NSManagedObjectContext) {
        let income = Income(context: context)
        income.id = UUID()
        income.date = Date()
        income.name = name
        income.amount = amount
        income.category = category
        income.date = date
        
        save(context: context)
    }
    
    func editIncome(income: Income, category:String, name:String, amount : Double, date: Date, context: NSManagedObjectContext) {
        income.date = Date()
        income.name = name
        income.amount = amount
        income.category = category
        income.date = date
        
        save(context: context)
    }
    
    func addCategory (name:String, image: String, context: NSManagedObjectContext) {
        let category = Category(context: context)
        category.id = UUID()
        category.name = name
        category.image = image
        
        save(context: context)
    }
    
    func editCategory(category: Category, name : String, image : String, context: NSManagedObjectContext) {
        category.name = name
        category.image = image
        
        save(context: context)
    }
    
    func addReminder (name: String, date: Date, context: NSManagedObjectContext) {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.name = name
        reminder.date = date
        do {
            try context.save()
            
            // Планирование уведомления
            scheduleNotification(for: reminder)
        } catch {
            print("Error saving reminder: \(error.localizedDescription)")
        }
        save(context: context)
    }
    
    
    func editReminder(reminder: Reminder, name : String, date: Date, context: NSManagedObjectContext) {
        reminder.name = name
        reminder.date = date
        
        save(context: context)
    }
    
    func addDebt(amountLent: Double, amountOwed: Double, dateTaken: Date, dateDue: Date, contactName: String, contactIdentifier: String, contactPhoneNumber: String, isReminderSet: Bool, context: NSManagedObjectContext) {
        let newDebt = Debt(context: context)
        newDebt.id = UUID()
        newDebt.amountLent = amountLent
        newDebt.amountOwed = amountOwed
        newDebt.dateTaken = dateTaken
        newDebt.dateDue = dateDue
        newDebt.contactName = contactName
        newDebt.contactIdentifier = contactIdentifier
        newDebt.contactPhoneNumber = contactPhoneNumber
        newDebt.isReminderSet = isReminderSet

        if isReminderSet {
            addReminder(name: "Вернуть долг \(contactName) - \(Int(amountOwed)) \(settings.selectedCurrency.sign)", date: dateDue, context: context)
        }

        do {
            try context.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }
    
    func editDebt(debt: Debt, amountLent: Double, amountOwed: Double, dateTaken: Date, dateDue: Date, contactName: String, contactIdentifier: String, contactPhoneNumber: String, isReminderSet: Bool, context: NSManagedObjectContext) {
        debt.amountLent = amountLent
        debt.amountOwed = amountOwed
        debt.dateTaken = dateTaken
        debt.dateDue = dateDue
        debt.contactName = contactName
        debt.contactIdentifier = contactIdentifier
        debt.contactPhoneNumber = contactPhoneNumber
        debt.isReminderSet = isReminderSet

        if isReminderSet {
            addReminder(name: "Вернуть долг \(contactName) - \(Int(amountOwed)) \(settings.selectedCurrency.sign)", date: dateDue, context: context)
        }

        do {
            try context.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }
    
    func addLent(amountLent: Double, amountOwed: Double, dateTaken: Date, dateDue: Date, contactName: String, contactIdentifier: String, contactPhoneNumber: String, isReminderSet: Bool, context: NSManagedObjectContext) {
        let lent = Lent(context: context)
        lent.id = UUID()
        lent.amountLent = amountLent
        lent.amountOwed = amountOwed
        lent.dateTaken = dateTaken
        lent.dateDue = dateDue
        lent.contactName = contactName
        lent.contactIdentifier = contactIdentifier
        lent.contactPhoneNumber = contactPhoneNumber
        lent.isReminderSet = isReminderSet

        if isReminderSet {
            addReminder(name: "Возврат долга от \(contactName) - \(Int(amountOwed)) \(settings.selectedCurrency.sign)", date: dateDue, context: context)
        }

        do {
            try context.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }
    
    func editLent(lent: Lent, amountLent: Double, amountOwed: Double, dateTaken: Date, dateDue: Date, contactName: String, contactIdentifier: String, contactPhoneNumber: String, isReminderSet: Bool, context: NSManagedObjectContext) {
         lent.amountLent = amountLent
         lent.amountOwed = amountOwed
         lent.dateTaken = dateTaken
         lent.dateDue = dateDue
         lent.contactName = contactName
         lent.contactIdentifier = contactIdentifier
         lent.contactPhoneNumber = contactPhoneNumber
         lent.isReminderSet = isReminderSet

        if isReminderSet {
            addReminder(name: "Возврат долга от \(contactName) - \(Int(amountOwed)) \(settings.selectedCurrency.sign)", date: dateDue, context: context)
        }

        do {
            try context.save()
        } catch {
            print("Ошибка сохранения долга: \(error.localizedDescription)")
        }
    }
    
    func getCurrentBalanceString(context: NSManagedObjectContext) -> String {
        let request: NSFetchRequest<Balance> = Balance.fetchRequest()

        do {
            let balances = try context.fetch(request)
            if let balance = balances.first {
                return String(format: "%.2f", balance.amount)
            } else {
                return ""
            }
        } catch {
            print("Error fetching balance: \(error.localizedDescription)")
            return ""
        }
    }
    
    func getCurrentBalance(context: NSManagedObjectContext) -> Double? {
        let request: NSFetchRequest<Balance> = Balance.fetchRequest()

        do {
            let balances = try context.fetch(request)
            if let balance = balances.first {
                return balance.amount
            } else {
                return nil
            }
        } catch {
            print("Error fetching balance: \(error.localizedDescription)")
            return nil
        }
    }

    func saveNewBalance(_ newBalance: Double, newBalanceValue: Double, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Balance> = Balance.fetchRequest()
        
        do {
            let balances = try context.fetch(request)
            if let balance = balances.first {
                balance.amount = newBalance
            } else {
                let newBalance = Balance(context: context)
                newBalance.amount = newBalanceValue
            }
            
            try context.save()
            print("баланс сохранен")
        } catch {
            print("Error saving new balance: \(error.localizedDescription)")
        }
    }
    
    private func scheduleNotification(for reminder: Reminder) {
            let content = UNMutableNotificationContent()
            content.title = "Напоминание"
            content.body = reminder.name ?? ""
            content.sound = UNNotificationSound.default
            
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }
    
    func getAllExpenses() -> [Expense] {
            let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
            
            do {
                let expenses = try managedObjContext.fetch(fetchRequest)
                return expenses
            } catch {
                print("Error fetching expenses: \(error.localizedDescription)")
                return []
            }
        }
    
    func getAllIncomes() -> [Income] {
            let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
            
            do {
                let incomes = try managedObjContext.fetch(fetchRequest)
                return incomes
            } catch {
                print("Error fetching expenses: \(error.localizedDescription)")
                return []
            }
        }
}


