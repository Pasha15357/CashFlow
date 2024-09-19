//
//  Debts.swift
//  CashFlow
//
//  Created by Паша on 3.07.24.
//

import SwiftUI
import CoreData

struct Debts: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Debt.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Debt.dateTaken, ascending: false)]) var debts: FetchedResults<Debt>
    @FetchRequest(entity: Lent.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Lent.dateTaken, ascending: false)]) var lents: FetchedResults<Lent>

    @State private var showingAddDebtView = false
    @State private var showingAddLentView = false
    @State private var showingEditLentView = false
    @State private var showingEditDebtView = false
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var showingAlert = false
    
    @State private var selectedLent: Lent? = nil // Переменная для хранения выбранного долга
    @State private var selectedLents: Lent? = nil // Переменная для хранения выбранного долга
    
    @State private var selectedDebt: Debt? = nil // Переменная для хранения выбранного долга
    @State private var selectedDebts: Debt? = nil // Переменная для хранения выбранного долга

    
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            VStack {
                Picker("Тип долгов", selection: $selectedTab) {
                    Text("Я должен").tag(0)
                    Text("Мне должны").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    if selectedTab == 1 {
                        ForEach(lents) { lent in
                            ZStack {
                                // Основная плашка с информацией
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(lent.contactName ?? "")")
                                            .font(.headline)
                                        Text("Сумма: \(String(format: "%.2f", lent.amountOwed)) \(settings.selectedCurrency.sign)")
                                        Text("Взял: \(lent.dateTaken ?? Date(), formatter: dateFormatter)")
                                        Text("Вернет: \(lent.dateDue ?? Date(), formatter: dateFormatter)")
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle()) // Делает всю плашку интерактивной
                                .onTapGesture {
                                    selectedLent = lent // Сохраняем выбранный долг
                                    showingEditLentView = true // Открываем лист для редактирования
                                }
                                
                                // Кнопки поверх плашки
                                HStack {
                                    Spacer()
                                    
                                    Circle()
                                        .fill(Color("iconsDebts"))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.green)
                                        )
                                        .onTapGesture {
                                            if let phoneNumber = lent.contactPhoneNumber?.replacingOccurrences(of: "-", with: ""),
                                               let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                                                UIApplication.shared.open(url)
                                            } else {
                                                print("Invalid phone number")
                                            }
                                        }
                                        .padding(.trailing, 10) // Немного отступаем вправо
                                    
                                    Circle()
                                        .fill(Color("iconsDebts"))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        )
                                        .onTapGesture {
                                            selectedLents = lent // Сохраняем выбранный долг
                                            showingAlert = true
                                        }
                                        .padding(.trailing, 10) // Общий отступ вправо
                                        .alert(isPresented: $showingAlert) {
                                            Alert(
                                                title: Text("Подтвердите действие"),
                                                message: Text("Вы уверены, что хотите завершить долг?"),
                                                primaryButton: .default(Text("Завершить")) {
                                                    if let selectedLents = selectedLents {
                                                        // Добавляем доход, так как долг был завершён
                                                        
                                                        DataController().addIncome(name: "Долг вернул \(selectedLents.contactName ?? "")", category: "Долг", amount: selectedLents.amountOwed, date: Date(), context: managedObjectContext)
                                                        
                                                        
                                                        // Удаляем выбранный долг из базы данных
                                                        managedObjectContext.delete(selectedLents)
                                                        
                                                        // Сохраняем изменения
                                                        do {
                                                            try managedObjectContext.save()
                                                        } catch {
                                                            print("Ошибка при сохранении контекста: \(error)")
                                                        }
                                                    }
                                                },
                                                secondaryButton: .cancel(Text("Отмена"))
                                            )
                                        }

                                }
                            }
                            .frame(maxWidth: .infinity) // Обеспечиваем, что ZStack занимает всю ширину
                        }
                        
                    } else {
                        ForEach(debts) { debt in
                            ZStack {
                                // Основная плашка с информацией
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(debt.contactName ?? "")")
                                            .font(.headline)
                                        Text("Сумма: \(String(format: "%.2f", debt.amountOwed)) \(settings.selectedCurrency.sign)")
                                        Text("Взял: \(debt.dateTaken ?? Date(), formatter: dateFormatter)")
                                        Text("Вернет: \(debt.dateDue ?? Date(), formatter: dateFormatter)")
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle()) // Делает всю плашку интерактивной
                                .onTapGesture {
                                    selectedDebt = debt // Сохраняем выбранный долг
                                    showingEditDebtView = true // Открываем лист для редактирования
                                }
                                
                                // Кнопки поверх плашки
                                HStack {
                                    Spacer()
                                    
                                    Circle()
                                        .fill(Color("iconsDebts"))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.green)
                                        )
                                        .onTapGesture {
                                            if let phoneNumber = debt.contactPhoneNumber?.replacingOccurrences(of: "-", with: ""),
                                               let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                                                UIApplication.shared.open(url)
                                            } else {
                                                print("Invalid phone number")
                                            }
                                        }
                                        .padding(.trailing, 10) // Немного отступаем вправо
                                    
                                    Circle()
                                        .fill(Color("iconsDebts"))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        )
                                        .onTapGesture {
                                            selectedDebts = debt // Сохраняем выбранный долг
                                            showingAlert = true
                                        }
                                        .padding(.trailing, 10) // Общий отступ вправо
                                        .alert(isPresented: $showingAlert) {
                                            Alert(
                                                title: Text("Подтвердите действие"),
                                                message: Text("Вы уверены, что хотите завершить долг?"),
                                                primaryButton: .default(Text("Завершить")) {
                                                    if let selectedDebts = selectedDebts {
                                                        // Добавляем доход, так как долг был завершён
                                                        
                                                        DataController().addExpense(name: "Вы вернули долг \(selectedDebts.contactName ?? "")", category: "Долг", amount: selectedDebts.amountOwed, date: Date(), context: managedObjectContext)
                                                        
                                                        
                                                        // Удаляем выбранный долг из базы данных
                                                        managedObjectContext.delete(selectedDebts)
                                                        
                                                        // Сохраняем изменения
                                                        do {
                                                            try managedObjectContext.save()
                                                        } catch {
                                                            print("Ошибка при сохранении контекста: \(error)")
                                                        }
                                                    }
                                                },
                                                secondaryButton: .cancel(Text("Отмена"))
                                            )
                                        }

                                }
                            }
                            .frame(maxWidth: .infinity) // Обеспечиваем, что ZStack занимает всю ширину
                        }
                    }
                }
                .listStyle(.plain)
            }
            
        }
        .navigationBarTitle("Долги")
        .navigationBarItems(trailing: Button(action: {
            if selectedTab == 1 {
                showingAddLentView = true
            } else {
                showingAddDebtView = true
            }
        }) {
            Image(systemName: "plus.circle")
        })
        .sheet(isPresented: $showingAddDebtView) {
            AddDebt().environment(\.managedObjectContext, managedObjectContext)
        }
        .sheet(isPresented: $showingAddLentView) {
            AddLent().environment(\.managedObjectContext, managedObjectContext)
        }
        .sheet(item: $selectedLent) { lent in
            EditLent(lent: lent).environment(\.managedObjectContext, managedObjectContext)
        }
        .sheet(item: $selectedDebt) { debt in
            EditDebt(debt: debt).environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

//func returnDebt(lent: Lent, context: NSManagedObjectContext) {
//
//}






#Preview {
    Debts()
}
