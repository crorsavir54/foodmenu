//
//  EditMenuView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditMenuView: View {
    
    @ObservedObject var mainCategories: OrderMenu
    @ObservedObject var orderViewModel: Orders
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink (destination: EditCategoryView(mainCategories: mainCategories)) {
                    Text("Categories")
                }
                NavigationLink (destination: EditItemsView(mainMenu: mainCategories)) {
                    Text("Items")
                }
                NavigationLink (destination: OrdersView(orderViewModel: orderViewModel)) {
                    Text("Orders")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Manage")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    HStack {
                        Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                        }).foregroundColor(.orange)
                        
                        Spacer()
                    }
                }
            }
            
        }
    }
}

struct EditMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EditMenuView(mainCategories: OrderMenu(), orderViewModel: Orders())
    }
}
