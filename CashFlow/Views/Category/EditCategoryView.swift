//
//  EditCategoryView.swift
//  CashFlow
//
//  Created by Паша on 29.02.24.
//

import SwiftUI

struct EditCategoryView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var category : FetchedResults<Category>.Element
    
    @State private var name = ""
    @State private var image = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Название", text: $name)
//                Picker("Категория", selection: $selectedCategory) {
//                    ForEach(categories, id: \.name) { category in
//                        Text(category.name).tag(category.name)
//                    }
//                }
                TextField("Картинка", text: $image)
                
                HStack {
                    Spacer()
                    Button ("Сохранить"){
                        DataController().editCategory(category: category, name: name, image: image, context: managedObjContext)
                        dismiss()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}


