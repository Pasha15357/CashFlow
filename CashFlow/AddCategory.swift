//
//  AddCategory.swift
//  CashFlow
//
//  Created by Паша on 23.11.23.
//

import SwiftUI




struct AddCategory: View {
    @State var newCreature : Creature = Creature(name: "", emoji: "")
    @EnvironmentObject var data : CreatureZoo
 
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Form {
                Section("Name") {
                    TextField("Name", text: $newCreature.name)
                    
                }
                
                Section("Emoji") {
                    TextField("Emoji", text: $newCreature.emoji)
                    
                }
                
                Section("Creature Preview") {
                    CreatureRow(creature: newCreature)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        data.creatures.append(newCreature)
                        dismiss()
                        
                    }
                }
            }
            
        }
    }
}

#Preview {
    NavigationView {
            AddCategory()
                .environmentObject(CreatureZoo())
        }
}

struct CreatureRow: View {
    var creature : Creature
    
    var body: some View {
        HStack {
            Text(creature.name)
                .font(.title)
            
            Spacer()
            
            Text(creature.emoji)
                .frame(minWidth: 125)
        }
        
        
    }
}
