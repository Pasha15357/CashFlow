//
//  ListOfCategories.swift
//  CashFlow
//
//  Created by Паша on 8.04.24.
//

import SwiftUI

struct ListOfCategories: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var showingAddView = false

    var body: some View {
        VStack{
            List {
                ForEach(categories) { category in
                    NavigationLink(destination: EditCategoryView(category: category)) {
                        HStack {
                            Image(systemName: "\(category.image!)")
                                .frame(width: 30) // Установите требуемый размер изображения
                            Text(category.name!)
                                .bold()
                        }
                        
                    }
                }
                .onDelete(perform: deleteCategory)
                HStack {
                    Spacer()
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Добавить категорию", systemImage: "plus.circle")
                    }
                    Spacer()
                }
            }
        }
        .navigationBarTitle("Категории")
        .sheet(isPresented: $showingAddView) {
            AddCategory()
        }
    }
    
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
}

#Preview {
    ListOfCategories()
}
