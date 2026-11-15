//
//  OnboardingView.swift
//  CashFlow
//
//  Created by Паша on 12/13/25.
//

import Foundation
import SwiftUI
import Network


struct OnboardingView: View {
    @State private var currentPage = 0
    var onFinish: () -> Void

    var body: some View {
        VStack {
            Text("Добро пожаловать в CashFlow")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            TabView(selection: $currentPage) {

                OnboardingCategories()
                    .tag(0)

                OnboardingCurrency()
                    .tag(1)

                OnboardingBalance(onFinish: onFinish)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            Button(action: {
                if currentPage < 2 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    onFinish()
                    
                }
            }) {
                Text(currentPage == 2 ? "Завершить" : "Далее")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct OnboardingCategories: View {
    @State private var showAddCategories = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Добавим категории")
                .font(.largeTitle)
                .bold()

            Text("Выберите нужные категории расходов и доходов")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            Button("Выбрать категории") {
                showAddCategories = true
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showAddCategories) {
            BasedCategories()
        }
    }
}

struct OnboardingCurrency: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var settings = Settings1()

    @State private var currentCurrencyIndex =
        UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Выберите валюту")
                .font(.largeTitle)
                .bold()

            Text("Мы будем использовать её для отображения всех сумм в приложении.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            Picker("Валюта", selection: $settings.selectedCurrencyIndex) {
                ForEach(0..<settings.currencies.count, id: \.self) { index in
                    Label(
                        settings.currencies[index].name,
                        systemImage: settings.currencies[index].systemImageName
                    )
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: settings.selectedCurrencyIndex) { newValue in
                Settings().checkInternetConnection { isConnected in
                    if isConnected {
                        UserDefaults.standard.setValue(newValue, forKey: "selectedCurrencyIndex")

                        let selectedCurrency = settings.currencies[newValue]
                        let currentCurrency = settings.currencies[currentCurrencyIndex]

                        Settings().convertAllAmounts(
                            from: currentCurrency,
                            to: selectedCurrency,
                            context: managedObjContext
                        )

                        currentCurrencyIndex = newValue
                    } else {
                        settings.showAlert = true
                        settings.selectedCurrencyIndex = currentCurrencyIndex
                    }
                }
            }
            .alert(isPresented: $settings.showAlert) {
                Alert(
                    title: Text("Нет интернета"),
                    message: Text("Для смены валюты требуется подключение"),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .padding()
    }
}



struct OnboardingBalance: View {
    @Environment(\.managedObjectContext) var context
    @State private var balance: Double = 0

    var onFinish: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Начальный баланс")
                .font(.largeTitle)
                .bold()

            Text("Укажите сумму, с которой вы начинаете вести учет.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            TextField("Введите сумму", value: $balance, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Сохранить") {
                saveBalance()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }

    private func saveBalance() {
        let newBalance = Balance(context: context)
        newBalance.amount = balance

        try? context.save()
    }
}

