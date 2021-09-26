//
//  EditItemsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditItemsView: View {
    @ObservedObject var mainMenu: OrderMenu
    @State var editMode: EditMode = .inactive
    @State var itemDetailsPresented = false
    @State var addNewitemDetailsPresented = false
    @State var selectedItem = CatItem(name: "", description: "")
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(mainMenu.items, id:\.self) { item in
                        HStack {
                            Image(item.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(item.name)
                                        .fontWeight(.semibold)
                                    Text("$\(item.price, specifier: "%.2f")")
                                        .font(.caption)
                                }
                                Text(item.description)
                                    .font(.caption2)
                                HStack (spacing: 0) {
                                    Text("Category > ")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Text("\(mainMenu.returnCategoryName(name: item.subcategory)) > ")
                                        .font(.caption2)
                                    Text(item.subcategory)
                                        .font(.caption2)
                                }
                            }
                        }
                        .onTapGesture {
                            selectedItem = item
                            itemDetailsPresented.toggle()
                        }
                    }
                }
                Button(action: {addNewitemDetailsPresented.toggle()}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
                .padding()
            }
        }
        .sheet(isPresented: $addNewitemDetailsPresented) {
            EditItemDetailsView(mainMenu: mainMenu, item: $selectedItem) {
                addedItem in
                mainMenu.insertItem(item: addedItem)
                addNewitemDetailsPresented = false
            }
        }
        .sheet(isPresented: $itemDetailsPresented) {
            EditItemDetailsView(mainMenu: mainMenu, item: $selectedItem) {
                updatedItem in
                mainMenu.insertItem(item: updatedItem)
                print(updatedItem)
                itemDetailsPresented = false
            }
        }
//        .environment(\.editMode, $editMode)
    }
}

struct EditItemsView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemsView(mainMenu: OrderMenu())
    }
}
