//
//  Settings.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import CoreData
import Network
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication



class Settings1: ObservableObject {
    @Published var selectedCurrencyIndex: Int = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
    @Published var showAlert: Bool = false

    var currencies: [Currency] = [
        Currency(name: "Доллар", code: "USD", systemImageName: "dollarsign.circle", sign: "$"),
        Currency(name: "Рос. руб", code: "RUB", systemImageName: "rublesign.circle", sign: "₽"),
        Currency(name: "Евро", code: "EUR", systemImageName: "eurosign.circle", sign: "€"),
        Currency(name: "Бел. руб", code: "BYN", systemImageName: "rublesign.circle", sign: "BYN")
    ]

    var selectedCurrency: Currency {
        return currencies[selectedCurrencyIndex]
    }
}

struct Currency {
    var name: String
    let code: String
    var systemImageName: String
    var sign: String
}

struct Settings: View {
    @Environment(\.managedObjectContext) var managedObjContext

    @State private var showingAddExpense = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

    @AppStorage("selectedLanguageIndex") private var selectedLanguageIndex = 0
    let languages = ["Русский", "English"]

    @State private var balanceInput: String = ""

    @StateObject var settings = Settings1()
    @State private var showingAddView = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var selectedImage: UIImage?

    static var selectedCurrencyIndex: Int = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
    @State private var selectedCurrencyIndex = Self.selectedCurrencyIndex
    @State private var currentCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
    @State private var isConnected: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false

    @AppStorage("isFaceIDOn") private var isFaceIDOn: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Профиль")) {
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        HStack(alignment: .center, spacing: 20) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                Text("\(firstName) \(lastName)")
                                    .font(.title2)
                                    .bold()
                            } else if status {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                Text("\(firstName) \(lastName)")
                                    .font(.title2)
                                    .bold()
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                Text("Вход")
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                HStack {
                    Image("dark-theme")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Toggle("Тёмная тема", isOn: $isDarkModeOn)
                        .onChange(of: isDarkModeOn) { newValue in
                            updateInterfaceStyle(isDarkMode: newValue)
                        }
                }

                HStack {
                    Image("faceid")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Toggle("Face ID", isOn: $isFaceIDOn)
                        .onChange(of: isFaceIDOn) { newValue in
                            if newValue {
                                requestFaceIDPermission()
                            }
                        }
                }

                HStack {
                    Image("language")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Picker("Язык", selection: $selectedLanguageIndex) {
                        ForEach(0..<languages.count) { index in
                            Text(languages[index])
                                .tag(index)
                        }
                    }
                }

                HStack {
                    Image("currency")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Picker("Валюта", selection: $settings.selectedCurrencyIndex) {
                        ForEach(0..<settings.currencies.count) { index in
                            Label(settings.currencies[index].name, systemImage: settings.currencies[index].systemImageName)
                        }
                    }
                    .onChange(of: settings.selectedCurrencyIndex) { newValue in
                        checkInternetConnection { isConnected in
                            if isConnected {
                                UserDefaults.standard.setValue(newValue, forKey: "selectedCurrencyIndex")
                                let selectedCurrency = settings.currencies[newValue]
                                let currentCurrency = settings.currencies[currentCurrencyIndex]
                                convertAllAmounts(from: currentCurrency, to: selectedCurrency, context: managedObjContext)
                                currentCurrencyIndex = newValue // Обновляем текущую валюту
                                balanceInput = DataController().getCurrentBalanceString(context: managedObjContext)

                            } else {
                                settings.showAlert = true
                                settings.selectedCurrencyIndex = currentCurrencyIndex
                            }
                        }
                    }
                    .alert(isPresented: $settings.showAlert) {
                        Alert(
                            title: Text("Нет подключения к интернету"),
                            message: Text("Пожалуйста, проверьте ваше интернет-соединение и попробуйте снова."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }

                NavigationLink(destination: EditBalance()) {
                    HStack {
                        Image("balance")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Баланс")
                        Spacer()
                        Text("\(balanceInput) \(settings.selectedCurrency.sign)")
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    balanceInput = String(format: "%.2f", DataController().getCurrentBalance(context: managedObjContext) ?? 0.0)
                    loadData()
                    selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
                    currentCurrencyIndex = selectedCurrencyIndex // Устанавливаем текущую валюту при загрузке
                    startNetworkMonitoring()
                }

                NavigationLink(destination: ListOfCategories(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))) {
                    HStack {
                        Image("category")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Категории")
                    }
                }

                NavigationLink(destination: ListOfReminders()) {
                    Image("reminders")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("Напоминания")
                }

                Button(action: {
                    showingAddView.toggle()
                }) {
                    HStack {
                        Image("export")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Экспорт")
                            .foregroundColor(Color("black_white"))
                    }
                }

                Section {
                    Button (action : {
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        loadData()
                    }) {
                        Text("Выйти").foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .sheet(isPresented: $showingAddView) {
                ExportView()
            }
            .navigationBarTitle("Настройки")
            .sheet(isPresented: $showingAddExpense) {
                Registration1()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AppleLanguagesDidChangeNotification"))) { _ in
            self.selectedLanguageIndex = UserDefaults.standard.integer(forKey: "selectedLanguageIndex")
        }
    }

    private func updateInterfaceStyle(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }

    private func requestFaceIDPermission() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Для использования Face ID, пожалуйста, авторизуйтесь."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if !success {
                        isFaceIDOn = false
                    }
                }
            }
        } else {
            isFaceIDOn = false
        }
    }

    

    func loadData() {
           guard let currentUser = Auth.auth().currentUser else { return }
           let db = Firestore.firestore()
           let userRef = db.collection("users").document(currentUser.uid)
           
           userRef.getDocument { document, error in
               if let document = document, document.exists {
                   let data = document.data()
                   firstName = data?["firstName"] as? String ?? ""
                   lastName = data?["lastName"] as? String ?? ""
                   
                   if let imageData = data?["profileImage"] as? Data {
                       if let profileImage = UIImage(data: imageData) {
                           self.selectedImage = profileImage
                       } else {
                           print("Failed to convert data to image")
                       }
                   } else {
                       print("Profile image data not found")
                   }
               } else {
                   print("Document does not exist")
               }
           }
       }

    func fetchExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void) {
            let urlString = "https://v6.exchangerate-api.com/v6/c2c2b2e04c632163049b130f/latest/\(fromCurrency)"
            
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
                    let exchangeRateResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                    completion(.success(exchangeRateResponse))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        
        struct ExchangeRateResponse: Codable {
            let result: String
            let conversionRates: [String: Double]
            
            enum CodingKeys: String, CodingKey {
                case result
                case conversionRates = "conversion_rates"
            }
        }
        
        func convertAllAmounts(from sourceCurrency: Currency, to targetCurrency: Currency, context: NSManagedObjectContext) {
            fetchExchangeRate(fromCurrency: sourceCurrency.code, toCurrency: targetCurrency.code) { result in
                switch result {
                case .success(let exchangeRateResponse):
                    context.perform {
                        let balanceFetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
                        let expenseFetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
                        let incomeFetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
                        
                        do {
                            let balances = try context.fetch(balanceFetchRequest)
                            let expenses = try context.fetch(expenseFetchRequest)
                            let incomes = try context.fetch(incomeFetchRequest)
                            
                            if let rate = exchangeRateResponse.conversionRates[targetCurrency.code] {
                                for balance in balances {
                                    balance.amount *= rate
                                }
                                
                                for expense in expenses {
                                    expense.amount *= rate
                                }
                                
                                for income in incomes {
                                    income.amount *= rate
                                }
                                
                                try context.save()
                            } else {
                                print("No exchange rate found for target currency \(targetCurrency.code)")
                            }
                        } catch {
                            print("Failed to fetch or save data: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch exchange rates: \(error)")
                }
            }
        }
        
        private func checkInternetConnection(completion: @escaping (Bool) -> Void) {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    completion(true)
                } else {
                    completion(false)
                }
                monitor.cancel()
            }
            let queue = DispatchQueue(label: "InternetConnectionMonitor")
            monitor.start(queue: queue)
        }
        
        private func startNetworkMonitoring() {
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    self.isConnected = path.status == .satisfied
                }
            }
            monitor.start(queue: queue)
        }
    
    
}


#Preview {
    Settings()
}
