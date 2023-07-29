//
//  ItemListView.swift
//  JsonCoreDataTutorial
//
//  Created by Eymen on 29.07.2023.
//

import SwiftUI

struct ItemListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: [])
    private var items: FetchedResults<Item>
    
    @State private var isPresentingAddıtemSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    Text(item.name ?? "Unknown")
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $isPresentingAddıtemSheet){
                AddItemView(isPresented: $isPresentingAddıtemSheet)
            }
        }
        .onAppear(perform: preloadData)
    }
    
    private func preloadData() {
        guard let  url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let itemsArray = try decoder.decode([ItemData].self, from: data)

            for itemData in itemsArray {
                addItem(itemData: itemData)
            }
            saveContext()
        } catch {
            print("Error loading data : \(error.localizedDescription)")
        }
    }
    
    private func addItem(itemData: ItemData) {
        withAnimation {
            
            if items.first(where: { $0.id == itemData.id }) == nil {
                let newItem = Item(context: viewContext)
                newItem.id = itemData.id
                newItem.name = itemData.name
                saveContext()
            }
        }
    }
    
    private var addButton: some View {
        Button {
            isPresentingAddıtemSheet = true
        } label: {
            Image(systemName: "plus")
        }

    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context : \(error.localizedDescription)")
        }
    }
}

struct ItemData: Codable {
    let id: String
    let name: String
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
