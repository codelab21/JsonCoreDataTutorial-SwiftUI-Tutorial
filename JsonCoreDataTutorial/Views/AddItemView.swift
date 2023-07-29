//
//  AddItemView.swift
//  JsonCoreDataTutorial
//
//  Created by Eymen on 29.07.2023.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool // To control the presentation of the bottom sheet
    @State private var itemName: String = ""
    
    var body: some View {
        VStack {
            TextField("Item Name", text: $itemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Item") {
                addItem()
            }
            .padding()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID().uuidString
            newItem.name = itemName // Use the value from the text field
            saveContext()
            isPresented = false // Dismiss the bottom sheet
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
