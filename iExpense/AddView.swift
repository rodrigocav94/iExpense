//
//  AddView.swift
//  iExpense
//
//  Created by Rodrigo Cavalcanti on 29/01/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var mostrandoNotificação = false
    @State private var mensagemNotificação = ""

    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    if name != "" {
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        mensagemNotificação = "Adicione um título."
                        mostrandoNotificação = true
                    }
                } else {
                    mensagemNotificação = "Adicione um valor."
                    mostrandoNotificação = true
                }
            })
            .alert(isPresented: $mostrandoNotificação, content: {
                Alert(title: Text("Não foi possível adicionar a nova despesa."), message: Text("\(mensagemNotificação)"), dismissButton: .default(Text("Continuar")))
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
