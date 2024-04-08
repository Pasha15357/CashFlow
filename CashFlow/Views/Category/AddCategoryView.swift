
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
        ("film", "Кино"),
    ] // Массив кортежей с пользовательскими иконками и их названиями
    
    let customIcons1 = [
        ("heart.fill", "Любовь"),
        ("book.fill", "Чтение"),
        ("music.note", "Музыка"),
        ("figure.pool.swim", "Плавание"),
        ("globe", "Путешествия"),
        ("camera.fill", "Фотография"),
        ("paintbrush.fill", "Живопись"),
        ("banknote", "Деньги"),
    ]
    
    let customIcons2 = [
        ("house.fill", "Дом"),
        ("car.fill", "Автомобиль"),
        ("briefcase.fill", "Работа"),
        ("gamecontroller.fill", "Игры"),
        ("graduationcap.fill", "Образование"),
        ("airplane", "Путешествия"),
        ("cart.fill", "Покупки"),
        ("gift.fill", "Подарки"),
    ]


    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории"))  {
                    TextField("Еда", text: $name)
                }
                Section(header: Text("Выберите иконку")) {
                    VStack {
                        Picker("Иконка", selection: $selectedIcon) {
                            ForEach(customIcons, id: \.0) { icon, iconName in
                                HStack {
                                    
                                    Image(systemName: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                }
                                .tag(icon) // Используем иконку в качестве тега
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Используем сегментированный стиль для Picker
                        Picker("Иконка", selection: $selectedIcon) {
                            ForEach(customIcons1, id: \.0) { icon, iconName in
                                HStack {
                                    
                                    Image(systemName: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                }
                                .tag(icon) // Используем иконку в качестве тега
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Используем сегментированный стиль для Picker
                        Picker("Иконка", selection: $selectedIcon) {
                            ForEach(customIcons2, id: \.0) { icon, iconName in
                                HStack {
                                    
                                    Image(systemName: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                }
                                .tag(icon) // Используем иконку в качестве тега
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // Используем сегментированный стиль для Picker
                    }
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
            .navigationTitle("Добавить категорию")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        dismiss()
                    }) {
                        Text("Отменить")
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
