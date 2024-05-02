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
    
    func addExpense (name:String, category:String, amount: Double, context: NSManagedObjectContext) {
        let expense = Expense(context: context)
        expense.id = UUID()
        expense.date = Date()
        expense.name = name
        expense.amount = amount
        expense.category = category
        
        save(context: context)
    }
    
    func editExpense(expense: Expense, category:String, name : String, amount : Double, context: NSManagedObjectContext) {
        expense.date = Date()
        expense.name = name
        expense.amount = amount
        expense.category = category
        
        save(context: context)
    }
    
    func addIncome (name:String, category:String, amount: Double, context: NSManagedObjectContext) {
        let income = Income(context: context)
        income.id = UUID()
        income.date = Date()
        income.name = name
        income.amount = amount
        income.category = category
        
        save(context: context)
    }
    
    func editIncome(income: Income, category:String, name:String, amount : Double, context: NSManagedObjectContext) {
        income.date = Date()
        income.name = name
        income.amount = amount
        income.category = category
        
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
    
    func addReminer (name:String, date: Date, context: NSManagedObjectContext) {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.name = name
        reminder.date = date
        
        save(context: context)
    }
    
    func editReminder(reminder: Reminder, name : String, date: Date, context: NSManagedObjectContext) {
        reminder.name = name
        reminder.date = date
        
        save(context: context)
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


}


