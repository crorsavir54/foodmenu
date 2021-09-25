//
//  EditCategoryDetailView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditCategoryDetailView: View {
    @Binding var category: MainCategory
    var body: some View {
        Form {
            Section(header: Text("Category name")) {
                TextField("Name theme", text: $category.name)
            }
            Section(header: Text("ICON")) {
                TextField("Name theme", text: $category.icon)
            }
        }
    }
}

struct EditCategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryDetailView(category: .constant(MainCategory(name: "Main", icon: "🍽")))
    }
}
