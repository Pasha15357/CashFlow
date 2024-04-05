//
//  Main.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI
import Foundation
import CoreData



struct Main: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest var category: FetchedResults<Category>
    
    @State private var showingAddView = false   
    
    @State private var name = ""
    @State private var amount: Double = 0
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: []) var categories: FetchedResults<Category>
    @State private var categoryNames: [String] = [] // Массив имен категорий
    @State private var selectedCategory: String = ""
    
    @State private var balanceInput = ""
    @State private var balance: Double = 0.0

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        VStack {
                            TextField("Введите ваш баланс", text: $balanceInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button("Сохранить") {
                                if let newBalance = Double(balanceInput) {
                                    saveNewBalance(newBalance)
                                }
                            }
                            
                        }
                        .onAppear {
                            balanceInput = String(DataController().getCurrentBalance(context: managedObjContext) ?? 0.0)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(sectionData) { item in
                                GeometryReader { geometry in
                                    SectionView(section: item)
                                        .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30)) / -20, axis: (x: 0, y: 10, z: 0))
                                }
                                .frame(width: 275, height: 275)
                            }
                        }
                        .padding(30)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 0)
                    
                    List {
                        ForEach(category) { category in
                            NavigationLink(destination: EditCategoryView(category: category)) {
                                HStack {
                                    Image(systemName: "\(category.image!)")
                                        .frame(width: 30) // Установите требуемый размер изображения
                                    Text(category.name!)
                                        .bold()
                                }

                            }
                        }
                        .onDelete(perform: deleteCategory)
                        HStack {
                            Spacer()
                            Button {
                                showingAddView.toggle()
                            } label: {
                                Label("Добавить категорию", systemImage: "plus.circle")
                            }
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
                .sheet(isPresented: $showingAddView) {
                    AddCategory()
                }
            .navigationTitle("Главная")
            }
        }

    }
    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { category[$0] }.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
    
    private func saveNewBalance(_ newBalance: Double) {
        // Создаем экземпляр DataController
        let dataController = DataController()
        // Вызываем метод saveNewBalance через экземпляр DataController, передавая новый баланс и объект контекста
        dataController.saveNewBalance(newBalance, newBalanceValue: newBalance, context: managedObjContext)
    }


    
}

#Preview {
    Main(category: FetchRequest(entity: Category.entity(), sortDescriptors: [], predicate: nil))
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
        .frame(width: 275, height: 275)
        .background(section.color)
        .cornerRadius(30)
        .shadow(color: section.color.opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

struct Section1 : Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var image: Image
    var color: Color
}

let sectionData = [
    Section1(title: "Как правильно экономить", text: "10 советов", image: Image("Coin"), color: Color(.green)),
    Section1(title: "Где и как лучше хранить деньги", text: "5 рекомендаций", image: Image("PiggyBank"), color: Color(.red)),
    Section1(title: "Наличные или банковский счет?", text: "Где лучше хранить сбережения", image: Image("CashCoin"), color: Color(.blue))
]
