//
//  CategoriesExpenses.swift
//  CashFlow
//
//  Created by Паша on 3.05.24.
//

import SwiftUI

struct CategoriesExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest var category: FetchedResults<Category>
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var showingAddView = false
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings


    var body: some View {
        VStack (alignment: .leading){
            List {
                ForEach(category) { category in
                    if totalExpensesCategory(category: category.name ?? "") != 0 {
                        NavigationLink(destination: ListOfExpensesCategories(category: category)) {
                            HStack {
                                Image(systemName: "\(category.image!)")
                                    .frame(width: 30) // Установите требуемый размер изображения
                                Text(category.name!)
                                    .bold()
                                Spacer()
                                Text("\(settings.selectedCurrency.sign)\(totalExpensesCategory(category: category.name ?? ""))")
                                    .foregroundColor(.red) // Используйте выбранную валюту из Settings
                                
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteCategory)
            }
        }
        .navigationBarTitle("Расходы(\(settings.selectedCurrency.sign)\(Int(totalExpenses())))")
        .sheet(isPresented: $showingAddView) {
            AddCategory()
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { category[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    private func totalExpensesCategory(category: String) -> Int {
        var amount : Int = 0
        for item in expense {
            if category == item.category {
                amount += Int(item.amount)
            }
        }
        return amount
//        return String(format: "%.0f", amount) // "%.2f" указывает, что нужно отобразить число с двумя знаками после запятой
    }
    
    private func totalExpenses() -> Double {
        var amount : Double = 0
        for item in expense {
            amount += item.amount
        }
        
        return amount
    }

}

#Preview {
    CategoriesExpenses(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
}
