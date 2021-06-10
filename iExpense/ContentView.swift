//
//  ContentView.swift
//  iExpense
//
//  Created by Rodrigo Cavalcanti on 29/01/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

func corDoFundo(numero: Int) -> Color {
    switch numero {
    case 0...9:
        return .green
    case 10...99:
        return .orange
    case 100...Int.max:
        return .red
    default:
        return .primary
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                //what does the .self mean? Well, if we had just used [ExpenseItem], Swift would want to know what we meant – are we trying to make a copy of the class? Were we planning to reference a static property or method? Did we perhaps mean to create an instance of the class? To avoid confusion – to say that we mean we’re referring to the type itself, known as the type object – we write .self after it.
                
                self.items = decoded
                return
            }
        }

        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(corDoFundo(numero: item.amount))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }
                .onDelete(perform: removeItems)
                .animation(.default)
            }
            .navigationBarTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if expenses.items != [] {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAddExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
