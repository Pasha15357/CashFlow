//
//  DataController.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "ExpenseModel")
    
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
    
    func editExpense(expense: Expense, name : String, amount : Double, context: NSManagedObjectContext) {
        expense.date = Date()
        expense.name = name
        expense.amount = amount
        
        save(context: context)
    }
    
    func addIncome (name:String, amount: Double, context: NSManagedObjectContext) {
        let income = Income(context: context)
        income.id = UUID()
        income.date = Date()
        income.name = name
        income.amount = amount
        
        save(context: context)
    }
    
    func editIncome(income: Income, name : String, amount : Double, context: NSManagedObjectContext) {
        income.date = Date()
        income.name = name
        income.amount = amount
        
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
}
