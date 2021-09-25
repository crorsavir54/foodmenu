//
//  EditMenuView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditMenuView: View {
    
    @ObservedObject var mainCategories: OrderMenu
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink (destination: EditCategoryView(mainCategories: mainCategories)) {
                    Text("Categories")
                }
                NavigationLink (destination: EditSubCategoryView(mainMenu: mainCategories)) {
                    Text("SubCategories")
                }
                NavigationLink (destination: EditItemsView(mainMenu: mainCategories)) {
                    Text("Items")
                }
            }
            .navigationTitle("Manage")
        }
    }
}

struct EditMenuView_Previews: PreviewProvider {
    static var previews: some View {
        EditMenuView(mainCategories: OrderMenu())
    }
}
