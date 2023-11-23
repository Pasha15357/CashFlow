//
//  Main.swift
//  CashFlow
//
//  Created by Паша on 22.11.23.
//

import SwiftUI

struct Category: Identifiable{
    var id = UUID()
    var name: String
    var image: Image
}

struct CategoryRow : View {
    var body: some View{
        Text("Some task")
    }
}

struct Main: View {
    @State private var users = ["Ian", "Maria"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    Text(user)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Главная")
        }
    }
    
    func delete(at offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
    
}

#Preview {
    Main()
}
