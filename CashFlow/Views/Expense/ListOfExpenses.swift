//
//  Expenses.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import CoreData


struct ListOfExpenses: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var expense: FetchedResults<Expense>
    
    @State private var showingAddView = false
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("\(Int(totalExpensesToday())) рублей за сегодня")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(expense) { expense in
                        NavigationLink(destination: EditExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), expense: expense)) {
                            HStack {
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(expense.name!)
                                        .bold()
                                    
                                    Text("\(Int(expense.amount))  рублей").foregroundColor(.red)
                                    Text(expense.category!)
                                        .bold()
                                                    
                                }
                                Spacer()
                                Text(calcTimeSince(date: expense.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .listStyle(.plain)
                
            }
            .navigationTitle("Расходы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Добавить расход", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddExpenseView(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expense[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalExpensesToday() -> Double {
        var amountToday : Double = 0
        for item in expense {
            if Calendar.current.isDateInToday(item.date!) {
                amountToday += item.amount
            }
        }
        
        return amountToday
    }
}


#Preview {
    ListOfExpenses()
}
