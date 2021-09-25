//
//  EditSubCategoryView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditSubCategoryView: View {
    @ObservedObject var mainMenu: OrderMenu

    var body: some View {
        NavigationView {
            List {
                ForEach(mainMenu.subCategories, id:\.self) { subcategory in
                
                        HStack {
                            Text(subcategory.name)
                        }
                    
                }
            }
        }
    }
}

struct EditSubCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditSubCategoryView(mainMenu: OrderMenu())
    }
}
