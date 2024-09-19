//
//  AddExpenseView.swift
//  CashFlow
//
//  Created by Паша on 28.02.24.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var amount = Double()
    @State private var date = Date()

    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>

    @State private var selectedCategory: Category?
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var showToast = false // Состояние для управления показом уведомления
    @State private var toastMessage = "" // Сообщение для уведомления

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Название расхода")) {
                        TextField("Леденец", text: $name)
                    }
                    Section(header: Text("Категория расхода"))  {
                        Menu {
                            ForEach(categories, id: \.self) { cat in
                                Button(action: {
                                    selectedCategory = cat
                                }) {
                                    Image(systemName: "\(cat.image!)")
                                    Text(cat.name ?? "")
                                }
                            }
                        } label: {
                            Image(systemName: "\(selectedCategory?.image ?? "")")
                            Text(selectedCategory?.name ?? "Выберите категорию")
                        }
                    }

                    Section(header: Text("Сумма расхода (\(settings.selectedCurrency.sign))")) {
                        TextField("Стоимость", value: $amount, formatter: AddIncomeView().formatter)
                            .keyboardType(.decimalPad)
                    }

                    Section(header: Text("Дата расхода")) {
                        DatePicker("Дата и время", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    }

                    Button("Сохранить") {
                        if let selectedCategory = selectedCategory {
                            let expenseAmount = amount
                            DataController().addExpense(name: name, category: selectedCategory.name ?? "", amount: amount, date: date, context: managedObjContext)

                            // Получаем текущий баланс
                            guard let currentBalance = DataController().getCurrentBalance(context: managedObjContext) else { return }

                            // Вычитаем сумму расхода из текущего баланса
                            let newBalance = currentBalance - expenseAmount

                            // Сохраняем измененный баланс обратно в Core Data
                            DataController().saveNewBalance(newBalance, newBalanceValue: newBalance, context: managedObjContext)

                            // Показ уведомления
                            toastMessage = "Расход успешно добавлен!"
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showToast = false
                                }
                            }

//                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                }
                .navigationTitle("Добавить расход")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Отменить")
                        }
                    }
                }

                if showToast {
                    ToastView(message: toastMessage) {
                        withAnimation {
                            showToast = false
                        }
                    }
                    .zIndex(1) // Устанавливаем на передний план
                }
            }
        }
    }
}



struct ToastView: View {
    var message: String
    var onDismiss: () -> Void

    @State private var offset: CGSize = .zero

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.body)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
                .offset(y: offset.height)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { _ in
                            if self.offset.height > 50 {
                                withAnimation {
                                    self.onDismiss()
                                }
                            } else {
                                self.offset = .zero
                            }
                        }
                )
        }
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
    }
}



#Preview {
    AddExpenseView()
}
