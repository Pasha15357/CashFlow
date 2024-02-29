//
//  AddCategory.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI

struct AddCategory: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
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
                        DataController().addCategory(name: name, image: image, context: managedObjContext)
                        dismiss()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
            AddCategory()
        }
}

