//
//  EditMenuView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditCategoryView: View {
    
    @ObservedObject var mainCategories: OrderMenu
    @State var selectedCategory: MainCategory = MainCategory(name: "Main", icon: "🍽")
    @State var selectedCategoryEdited: MainCategory = MainCategory(name: "Main", icon: "🍽")
    @State var isCategoryDetailPresented = false
    
    var body: some View {
        List {
            ForEach(mainCategories.categories, id:\.self) { category in
                HStack {
                    Text(category.name)
                    Text(category.icon)
                }
                .onTapGesture {
                    selectedCategory = category
                    isCategoryDetailPresented.toggle()
                }
            }
        }.sheet(isPresented: $isCategoryDetailPresented, onDismiss: didDismiss) {
            EditCategoryDetailView(category: $selectedCategoryEdited)
        }
    }
    
    func didDismiss() {
        if selectedCategory != selectedCategoryEdited {
            mainCategories.insertCategory(category: selectedCategoryEdited)
        }
    }
}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(mainCategories: OrderMenu(), selectedCategory: MainCategory(name: "Main", icon: "🍽"))
    }
}
