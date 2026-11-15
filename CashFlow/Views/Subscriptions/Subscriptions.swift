//
//  SubscriptionsView.swift
//  CashFlow
//
//  Created by Паша on 30.09.24.
//

import SwiftUI
import CoreData

struct SubscriptionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Subscription.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Subscription.startDate, ascending: false)]
    ) var subscriptions: FetchedResults<Subscription>
    
    @StateObject var settings = Settings1() // Создаем экземпляр Settings
    @State private var showingAddSubscription = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(subscriptions, id: \.self) { subscription in
                        NavigationLink(destination: EditSubscription(subscription: subscription)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(subscription.name ?? "Без названия")
                                            .font(.title)
                                        HStack {
                                            Image("\(subscription.serviceIcon ?? "spotify")")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                
                                            Text(subscription.service ?? "")
                                                .font(.title2)
                                            
                                        }
                                        Text("Частота: \(subscription.paymentFrequency ?? "")")
                                            .font(.footnote)
                                        Text("Длительность: \(subscription.duration) месяцев")
                                            .font(.footnote)
                                    }
                                    Spacer()
                                    Text("\(String(format: "%.f", subscription.amount)) \(settings.selectedCurrency.sign)")
                                        .font(.title2)
                                        .bold()
                                }
                                
                            }
                        }
                    }
                    .onDelete(perform: deleteSubscription)
                }
                
            }
            .navigationBarTitle("Подписки")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSubscription = true
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
                
            }
            .sheet(isPresented: $showingAddSubscription) {
                AddSubscriptionView()
                    .environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }

    private func deleteSubscription(at offsets: IndexSet) {
        for index in offsets {
            let subscription = subscriptions[index]
            managedObjectContext.delete(subscription)
        }

        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to delete subscription: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SubscriptionsView()
}
