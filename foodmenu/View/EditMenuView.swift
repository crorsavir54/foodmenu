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
    @State var showSigninForm = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink (destination: EditCategoryView(mainCategories: mainCategories)) {
                    HStack {
                        Image(systemName: "rectangle.3.group.bubble.left")
                            .foregroundStyle(.orange, .orange)
                        Text("Categories")
                        
                    }
                    
                }
                NavigationLink (destination: EditItemsView(mainMenu: mainCategories)) {
                    HStack {
                        Image(systemName: "list.bullet.circle.fill")
                            .foregroundStyle(.white, .orange)
                        Text("Items")
                        
                    }
                    
                }
                NavigationLink (destination: OrdersView(orderViewModel: orderViewModel)) {
                    HStack {
                        Image(systemName: "cart.circle.fill")
                            .foregroundStyle(.white, .orange)
                        Text("Orders")
                        
                    }
                    
                }
                NavigationLink (destination: Home()) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundStyle(.white, .orange)
                        Text("Account")
                        
                    }
                    
//                    Image(systemName: "person.crop.circle.fill")
//                        .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(.insetGrouped)
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
