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
    @EnvironmentObject var auth: Authentication
    @Environment(\.presentationMode) var presentationMode
    @State var showSigninForm = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink (destination: EditCategoryView(mainCategories: mainCategories)) {
                    Label {
                        Text("Categories")
                        
                    } icon: {
                        ZStack {
                            Image(systemName: "square.fill")
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                            Image(systemName: "menucard")
                                .foregroundColor(.white)
//                                .font(.b)

                        }
                        
                    }
                }
                NavigationLink (destination: EditItemsView(mainMenu: mainCategories)) {
                    Label {
                        Text("Items")
                        
                    } icon: {
                        ZStack {
                            Image(systemName: "square.fill")
                                .foregroundColor(.pink)
                                .font(.largeTitle)
                            Image(systemName: "list.dash")
                                .foregroundColor(.white)
                        }
                    }
                }
                NavigationLink (destination: OrdersView(orderViewModel: orderViewModel)) {
                    Label {
                        Text("Orders")
                        
                    } icon: {
                        ZStack {
                            Image(systemName: "square.fill")
                                .foregroundColor(.indigo)
                                .font(.largeTitle)
                            Image(systemName: "cart.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
                NavigationLink (destination: Home()) {
                    Label {
                        Text("Account")
                        
                    } icon: {
                        ZStack {
                            Image(systemName: "person.crop.square.fill")
                                .foregroundColor(.orange)
                                .font(.largeTitle)
                        }
                    }
                }
            }
            .onAppear {
                if auth.loggedOut {
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                    
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
