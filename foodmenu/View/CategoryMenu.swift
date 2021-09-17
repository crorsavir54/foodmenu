//
//  CategoryMenu.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/17/21.
//

import SwiftUI

struct CategoryMenu: View {
    @Binding var category: String
    var body: some View {
        Text(category)
    }
}

struct CategoryMenu_Previews: PreviewProvider {
    static var previews: some View {
        CategoryMenu(category: .constant("Main"))
    }
}
