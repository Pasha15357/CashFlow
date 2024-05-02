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
        ("tshirt.fill", "Одежда"),
        ("camera.fill", "Фотография"),
        ("paintbrush.fill", "Живопись"),
        ("banknote", "Деньги"),
    ]
    
    let customIcons2 = [
        ("house.fill", "Дом"),
        ("car.fill", "Автомобиль"),
        ("briefcase.fill", "Работа"),
        ("pill", "Лекарства"),
        ("graduationcap.fill", "Образование"),
        ("airplane", "Путешествия"),
        ("cart.fill", "Покупки"),
        ("percent", "Долг"),
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название категории"))  {
                    TextField("Еда", text: $name)
                        .onAppear {
                            name = category.name!
                            selectedIcon = category.image!
                        }
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
                            DataController().editCategory(category: category, name: name, image: selectedIcon, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Категория")
    }
}


