//
//  Main.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI



struct Main: View {
    

    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (spacing: 20) {
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
                Spacer()
//                Section(header: Text("Категории")){
//                    ForEach (categories) { category in
//                        NavigationLink(destination: CategoryView(category: category)) {
//                            CategoryRow(category: category)
//                        }
//
//                    }
//                    .onMove(perform: move)
//                    .onDelete(perform: delete)
//                    NavigationLink(destination: AddCategory()) {
//                        Text("Добавить категорию..")
//                    }
//                }
                
            }
            .navigationTitle("Главная")
            
        }
        
    }
    
    
    
}

#Preview {
    Main()
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
                Spacer()
                
            }
            Spacer()
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
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
