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
    @State private var selectedIcon: String = "" // Переменная для хранения выбранной иконки
    
    let customIcons = [
        ("bus", "Транспорт"),
        ("oilcan", "Бензин"),
        ("fork.knife.circle", "Еда"),
        ("gamecontroller", "Игры"),
        ("antenna.radiowaves.left.and.right", "Связь"),
        ("figure.run", "Игры"),
        ("gift", "Подарки"),
    ] // Массив кортежей с пользовательскими иконками и их названиями
    
    var body: some View {
        Form {
            Section {
                TextField("Название", text: $name)
                
                VStack {
                    HStack {
                        Text("Иконка")
                        Spacer()
                    }
                    Picker("Иконка", selection: $selectedIcon) {
                        ForEach(customIcons, id: \.0) { icon, iconName in
                            HStack {
                                
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
    //                            Text(iconName)
    //                                .font(.caption)
                            }
                            .tag(icon) // Используем иконку в качестве тега
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Используем сегментированный стиль для Picker
                }
                

                Section {
                    HStack {
                        Spacer()
                        Button ("Сохранить") {
                            DataController().addCategory(name: name, image: selectedIcon, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
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

