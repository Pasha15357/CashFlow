//
//  BasedCategories.swift
//  CashFlow
//
//  Created by Паша on 10/11/2024.
//

import SwiftUI

struct BasedCategories: View {
    // Массив данных для категорий с состоянием "выбрано" для каждой категории
    @State private var categories = [
        ExpenseCategory(icon: "bus", name: "Транспорт", isSelected: false),
        ExpenseCategory(icon: "oilcan.fill", name: "Бензин", isSelected: false),
        ExpenseCategory(icon: "fork.knife.circle", name: "Еда", isSelected: false),
        ExpenseCategory(icon: "gamecontroller.fill", name: "Игры", isSelected: false),
        ExpenseCategory(icon: "antenna.radiowaves.left.and.right", name: "Связь", isSelected: false),
        ExpenseCategory(icon: "figure.run", name: "Занятия спортом", isSelected: false),
        ExpenseCategory(icon: "gift", name: "Подарки", isSelected: false),
        ExpenseCategory(icon: "film", name: "Кино", isSelected: false),
        ExpenseCategory(icon: "heart.fill", name: "Любовь", isSelected: false),
        ExpenseCategory(icon: "book.fill", name: "Чтение", isSelected: false),
        ExpenseCategory(icon: "music.note", name: "Музыка", isSelected: false),
        ExpenseCategory(icon: "figure.pool.swim", name: "Плавание", isSelected: false),
        ExpenseCategory(icon: "tshirt.fill", name: "Одежда", isSelected: false),
        ExpenseCategory(icon: "camera.fill", name: "Фотография", isSelected: false),
        ExpenseCategory(icon: "paintbrush.fill", name: "Живопись", isSelected: false),
        ExpenseCategory(icon: "banknote", name: "Деньги", isSelected: false),
        ExpenseCategory(icon: "house.fill", name: "Дом", isSelected: false),
        ExpenseCategory(icon: "car.fill", name: "Автомобиль", isSelected: false),
        ExpenseCategory(icon: "briefcase.fill", name: "Работа", isSelected: false),
        ExpenseCategory(icon: "pill", name: "Лекарства", isSelected: false),
        ExpenseCategory(icon: "graduationcap.fill", name: "Образование", isSelected: false),
        ExpenseCategory(icon: "airplane", name: "Путешествия", isSelected: false),
        ExpenseCategory(icon: "cart.fill", name: "Покупки", isSelected: false),
        ExpenseCategory(icon: "percent", name: "Долг", isSelected: false)
    ]
    
    // Свойства для управления CoreData и закрытия окна
    @Environment(\.managedObjectContext) private var managedObjContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // Список категорий
                    List {
                        ForEach($categories) { $category in
                            HStack {
                                Image(systemName: category.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                Text(category.name)
                                    .font(.body)
                                
                                Spacer()
                                
                                // Чекбокс для выбора
                                Button(action: {
                                    category.isSelected.toggle()
                                }) {
                                    Image(systemName: category.isSelected ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(category.isSelected ? .green : .gray)
                                        .frame(width: 24, height: 24)
                                }
                                .buttonStyle(BorderlessButtonStyle()) // Чтобы избежать конфликта с List
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Spacer()
                    
                    // Кнопка "Сохранить"
                    Button(action: saveSelectedCategories) {
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
            }
            .navigationTitle("Добавить категории")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Отменить")
                    }
                }
            }
        }
    }
    
    // Метод для сохранения выбранных категорий
    private func saveSelectedCategories() {
        let selectedCategories = categories.filter { $0.isSelected }
        for category in selectedCategories {
            DataController().addCategory(name: category.name, image: category.icon, context: managedObjContext)
        }
        dismiss() // Закрыть экран после сохранения
    }
}

// Модель данных для категории
struct ExpenseCategory: Identifiable {
    let id = UUID()
    var icon: String
    var name: String
    var isSelected: Bool
}

#Preview {
    BasedCategories()
}
