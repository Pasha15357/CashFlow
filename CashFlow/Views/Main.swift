//
//  Main.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI
import Foundation
import CoreData
import Charts
import CloudKit


struct Main: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest var category: FetchedResults<Category>
    
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
    
    @Binding var selectedView: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        VStack {
                            Text("")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .onAppear {
                            balanceInput = String(DataController().getCurrentBalance(context: managedObjContext) ?? 0.0)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sectionData) { item in
                                NavigationLink(destination: item.destination) {
                                    GeometryReader { geometry in
                                        SectionView(section: item)
                                            .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30)) / -20, axis: (x: 0, y: 10, z: 0))
                                    }
                                    .frame(width: 200, height: 200)
                                }
                            }
                        }
                        .padding(30)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 0)
                    VStack(alignment: .leading) {
                        ZStack(alignment: .center)  {
                            Chart(expenses.map { income in
                                ExpenseData(name: income.name ?? "", amount: Int(income.amount), category: income.category ?? "")
                            }, id: \.name) { income in
                                if #available(iOS 17.0, *) {
                                    SectorMark(
                                        angle: .value ("Macros", income.amount),
                                        innerRadius: .ratio(0.618),
                                        outerRadius: .inset(1),
                                        angularInset: 1
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle (by: .value("Name", income.category))
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            .frame(height: 300)
                            .chartXAxis(.hidden)
                            Text("Расходы")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                }
                .listStyle(.plain)
                .sheet(isPresented: $showingAddView) {
                    AddCategory()
                }
//            .navigationTitle("Баланс: \(settings.selectedCurrency.sign)\(balanceInput)")
            
            }
        }
        .onAppear {
            // Обновляем выбранную валюту при открытии страницы
            settings.selectedCurrencyIndex = UserDefaults.standard.integer(forKey: "selectedCurrencyIndex")
        }

    }
    
    
    


    
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        let selectedView = Binding.constant(1)
        return Main(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil), selectedView: selectedView)
    }
}



struct SectionView: View {
    var section: Section1
    var body: some View {
        VStack {
            HStack {
                Text(section.title)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 160, alignment: .leading)
                    .foregroundColor(.white)
                    .bold()
                Spacer()
                
            }
            Spacer()
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
            section.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding()
            
        }
        
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: 200, height: 200)
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
    var destination: AnyView // Новое поле для хранения представления назначения
}


let sectionData = [
    Section1(title: "Как правильно экономить", text: "10 советов", image: Image("Coin"), color: Color("widget1"), destination: AnyView(Widget1())),
    Section1(title: "Где и как лучше хранить деньги", text: "5 рекомендаций", image: Image("PiggyBank"), color: Color("widget2"), destination: AnyView(Widget2())), // замените Widget2 на фактическое представление
    Section1(title: "Наличные или банковский счет?", text: "Где лучше хранить сбережения", image: Image("CashCoin"), color: Color("widget3"), destination: AnyView(Widget3())) // замените Widget3 на фактическое представление
]

