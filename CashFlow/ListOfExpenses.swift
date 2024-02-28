//
//  Expenses.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import CoreData


public class ExpenseItemEntity: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var amount: Int
    @NSManaged public var category: String
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "CashFlow") // Название вашей CoreData модели
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItemEntity]()
    
    init() {
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let request: NSFetchRequest<ExpenseItemEntity> = ExpenseItemEntity.fetchRequest() as! NSFetchRequest<ExpenseItemEntity>
        
        do {
            self.items = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
        }
    }

    
    func saveExpense(name: String, type: String, amount: Int64, category: String) {
        let newItem = ExpenseItemEntity(context: PersistenceController.shared.container.viewContext)
        newItem.name = name
        newItem.type = type
        newItem.amount = Int(amount)
        newItem.category = category
        
        do {
            try PersistenceController.shared.container.viewContext.save()
            fetchExpenses() // Refresh the items array
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
}



class CreatureZoo : ObservableObject {

 @Published var creatures = [
        Creature(name: "Gorilla", emoji: "🦍"),
        Creature(name: "Peacock", emoji: "🦚"),
        Creature(name: "Squid", emoji: "🦑"),
        Creature(name: "T-Rex", emoji: "🦖"),
        Creature(name: "Ladybug", emoji: "🐞"),
    ]
}

struct Creature : Identifiable {
    var name : String
    var emoji : String
    
    var id = UUID()
    var offset = CGSize.zero
    var rotation : Angle = Angle(degrees: 0)
}

struct ListOfExpenses: View {
    @State private var showingAddExpense = false
    @ObservedObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            List {
                ForEach (expenses.items, id: \.self) { item in // Используйте id для идентификации элементов
                    HStack {
                        VStack (alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("История")
            .navigationBarItems(leading:
                                    Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "minus")
            }, trailing:
                                    Button(action: {
                self.showingAddExpense = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddExpense(expenses: self.expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses.items[index]
            PersistenceController.shared.container.viewContext.delete(expense)
        }
        do {
            try PersistenceController.shared.container.viewContext.save()
            expenses.fetchExpenses() // Refresh the items array
        } catch {
            print("Error deleting expenses: \(error.localizedDescription)")
        }
    }
}


#Preview {
    ListOfExpenses()
}
