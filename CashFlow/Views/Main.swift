//
//  Main.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

// Main.swift
import SwiftUI
import Foundation
import CoreData
import Charts
import CloudKit


class ExchangeRates: ObservableObject {
    @Published var usdToByn: Double?
    @Published var eurToByn: Double?
    @Published var rubToByn: Double?
    
    func fetchRates() {
        let group = DispatchGroup()
        
        group.enter()
        fetchExchangeRate(fromCurrency: "USD", toCurrency: "BYN") { result in
            switch result {
            case .success(let rate):
                DispatchQueue.main.async {
                    self.usdToByn = rate
                }
            case .failure(let error):
                print("Failed to fetch USD to BYN rate: \(error)")
            }
            group.leave()
        }
        
        group.enter()
        fetchExchangeRate(fromCurrency: "EUR", toCurrency: "BYN") { result in
            switch result {
            case .success(let rate):
                DispatchQueue.main.async {
                    self.eurToByn = rate
                }
            case .failure(let error):
                print("Failed to fetch EUR to BYN rate: \(error)")
            }
            group.leave()
        }
        
        group.enter()
        fetchExchangeRate(fromCurrency: "RUB", toCurrency: "BYN") { result in
            switch result {
            case .success(let rate):
                DispatchQueue.main.async {
                    self.rubToByn = rate * 100
                }
            case .failure(let error):
                print("Failed to fetch RUB to BYN rate: \(error)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("All exchange rates fetched.")
        }
    }
    
    private func fetchExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let urlString = "https://v6.exchangerate-api.com/v6/c2c2b2e04c632163049b130f/latest/\(fromCurrency)"
//        let urlString = ""
        
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
                if let rate = exchangeRateResponse.conversionRates[toCurrency] {
                    completion(.success(rate))
                } else {
                    completion(.failure(NSError(domain: "No exchange rate found", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


struct ExchangeRateResponse: Codable {
    let result: String
    let conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case conversionRates = "conversion_rates"
    }
}


struct ExchangeRateWidget: View {
    var currency: String
    var rate: Double?
    var baseValue: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(format: "%.0f %@", baseValue, currency))
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            if let rate = rate {
                HStack {
                    Text(String(format: "%.2f BYN", rate))
                        .font(.title3)
                        .foregroundColor(.green)
                }
            } else {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding(5)
        .frame(width: 170, height: 100)
        .background(.black)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 10)
    }
}



struct Main: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State private var showingAddView = false
    
    @State private var name = ""
    @State private var amount: Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: [], animation: .default) private var expenses: FetchedResults<Expense>
    
    @State private var categoryNames: [String] = [] // Массив имен категорий
    @State private var selectedCategory: String = ""
    
    @State private var balanceInput = ""
    @State private var balance: Double = 0.0

    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    @StateObject var exchangeRates = ExchangeRates() // Создаем экземпляр ExchangeRates
    
    @Binding var selectedView: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sectionData) { item in
                                NavigationLink(destination: item.destination) {
                                    GeometryReader { geometry in
                                        SectionView(section: item)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30)) / -20, axis: (x: 0, y: 10, z: 0))
                                    }
                                    .frame(width: 170, height: 170)
                                }
                            }
                        }
                        .padding(30)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 0)
                    
                    VStack(alignment: .leading) { // Выравнивание содержимого по левому краю
                        NavigationLink(destination: Diagram()) {
                            VStack {
                                Chart(expenses.map { expense in
                                    ExpenseData(name: expense.name ?? "", amount: Int(expense.amount), category: expense.category ?? "")
                                }, id: \.name) { expense in
                                    if #available(iOS 17.0, *) {
                                        SectorMark(
                                            angle: .value("Amount", expense.amount),
                                            innerRadius: .ratio(0.618),
                                            angularInset: 1.5
                                        )
                                        .cornerRadius(4)
                                        .foregroundStyle(by: .value("Name", expense.category))
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                                .frame(height: 300)
                                .chartXAxis {
                                    AxisMarks(position: .bottom, values: .stride(by: 1)) { value in
                                        AxisValueLabel()
                                    }
                                }
                                .chartXAxis(.hidden)
                            }
                        }
                        .font(.title)
                        .fontWeight(.bold) // Установка жирного шрифта
                    }
                    .padding()
                    // Виджеты курсов валют
                    VStack (alignment: .leading) {
                        HStack {
                            Text("Актуальные курсы валют")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 10)
                            .padding(.horizontal, 30)
                            
                            Button (action: {
                                exchangeRates.fetchRates() // Fetch exchange rates on appear
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(Color("black_white"))
                            }
                            
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ExchangeRateWidget(currency: "USD", rate: exchangeRates.usdToByn, baseValue: 1)
                                ExchangeRateWidget(currency: "EUR", rate: exchangeRates.eurToByn, baseValue: 1)
                                ExchangeRateWidget(currency: "RUB", rate: exchangeRates.rubToByn, baseValue: 100)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 30)
                        }
                    }
                    .padding(.vertical, 20)
                    Divider()
                    NavigationLink(destination: EditBalance()) {
                        HStack {
                            Image("balance")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            Text("Баланс")
                                .bold()
                                .foregroundColor(Color("black_white"))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    Divider()
                    
                    NavigationLink(destination: ListOfCategories()) {
                        HStack {
                            Image("category")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            Text("Категории")
                                .bold()
                                .foregroundColor(Color("black_white"))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    Divider()
                    
                    NavigationLink(destination: ListOfReminders()) {
                        HStack {
                            Image("reminders")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            Text("Напоминания")
                                .bold()
                                .foregroundColor(Color("black_white"))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    Divider()
                    
                    NavigationLink(destination: Debts()) {
                        HStack {
                            Image("debts")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                            Text("Долги")
                                .bold()
                                .foregroundColor(Color("black_white"))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    Divider()
                    
                }
                .navigationTitle("Главная")
                .sheet(isPresented: $showingAddView) {
                    AddCategory()
                }
            }
        }
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
            exchangeRates.fetchRates() // Fetch exchange rates on appear
        }
        
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        let selectedView = Binding.constant(1)
        return Main(selectedView: selectedView)
    }
}

struct SectionView: View {
    var section: Section1
    var body: some View {
        VStack {
            Text(section.title)
                .font(.system(size: 15, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .bold()
            Spacer()
            Text(section.text.uppercased())
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: 170, height: 170)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

struct Section1: Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var image: Image
    var color: Color
    var destination: AnyView
}

let sectionData = [
    Section1(title: "Как правильно экономить", text: "10 советов", image: Image("Coin"), color: Color("widget1"), destination: AnyView(Widget1())),
    Section1(title: "Где и как лучше хранить деньги", text: "5 рекомендаций", image: Image("PiggyBank"), color: Color("widget2"), destination: AnyView(Widget2())),
    Section1(title: "Наличные или банковский счет?", text: "Где хранить сбережения", image: Image("CashCoin"), color: Color("widget3"), destination: AnyView(Widget3()))
]
