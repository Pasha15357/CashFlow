//
//  Settings.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Settings: View {
    @Environment(\.managedObjectContext) var managedObjContext

    @State private var showingAddExpense = false
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    @AppStorage("selectedLanguageIndex") private var selectedLanguageIndex = 0
    let languages = ["Русский", "English"] // Список доступных языков

    @State private var balanceInput = ""
    @State private var balance: Double = 0.0

    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    
    @State private var showingAddView = false
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var selectedImage: UIImage?


    
    struct Currency {
        var name: String
        var systemImageName: String
        var sign: String
    }
    
    static var selectedCurrencyIndex: Int = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex") // Объявляем selectedCurrencyIndex как static
        
        @State private var selectedCurrencyIndex = Self.selectedCurrencyIndex // Здесь используем static selectedCurrencyIndex
    let currencies: [Currency] = [
        Currency(name: "Доллар", systemImageName: "dollarsign.circle", sign: "$"),
        Currency(name: "Рубль", systemImageName: "rublesign.circle", sign: "₽"),
        Currency(name: "Евро", systemImageName: "eurosign.circle", sign: "€")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Профиль")) {
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        HStack (alignment: .center, spacing: 20){
                            
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                Text("\(firstName) \(lastName)")
                                    .font(.title2)
                                    .bold()
                                
                                
                            }
                            else if status{
                                Image(systemName: "person.crop.circle")
                                    .resizable()

                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fit)
                                Text("\(firstName) \(lastName)")
                                    .font(.title2)
                                    .bold()
                            }
                            else {
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
                            if newValue {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                            } else {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                            }
                    }
                }
                HStack {
                    Image("language")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Picker("Язык", selection: $selectedLanguageIndex) {
                                        ForEach(0 ..< languages.count) { index in
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
                    Picker("Валюта", selection: $selectedCurrencyIndex) {
                        ForEach(0..<currencies.count) { index in
                            Label(currencies[index].name, systemImage: currencies[index].systemImageName)
                        }
                    }
                    .onChange(of: selectedCurrencyIndex) { newValue in
                        UserDefaults.standard.setValue(newValue, forKey: "selectedCurrencyIndex")
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
                        Text("\(settings.selectedCurrency.sign)\(balanceInput)")
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    balanceInput = String(DataController().getCurrentBalance(context: managedObjContext) ?? 0.0)
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
                    .frame(maxWidth: .infinity, alignment: .center) // Центрируем кнопку
                }
            }
            .sheet(isPresented: $showingAddView) {
                ExportView()
            }
            .navigationBarTitle("Настройки")
            .onAppear(perform: loadData)
            .sheet(isPresented: $showingAddExpense) {
                Registration1()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AppleLanguagesDidChangeNotification"))) { _ in
                    // Перезагрузка представления после изменения языка
                    self.selectedLanguageIndex = UserDefaults.standard.integer(forKey: "selectedLanguageIndex")
                }
    }
    
    
    func loadData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        // Загрузка данных профиля пользователя из Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                firstName = data?["firstName"] as? String ?? ""
                lastName = data?["lastName"] as? String ?? ""
                
                // Попытка получить данные изображения
                if let imageData = data?["profileImage"] as? Data {
                    if let profileImage = UIImage(data: imageData) {
                        // Если изображение удалось преобразовать, устанавливаем его
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

    
}


#Preview {
    Settings()
}


