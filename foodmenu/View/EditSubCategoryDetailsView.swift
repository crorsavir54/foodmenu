//
//  EditSubCategoryDetailsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/26/21.
//

import SwiftUI

struct EditSubCategoryDetailsView: View {
    @ObservedObject var mainMenu: OrderMenu
    @Binding var subCategory: SubCat
    var didAddSubCategory: (_ item: SubCat) -> Void
    @State private var selectedCategory = ""
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(mainMenu.allCategories(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.inline)
                }
            }
            Button("Create Item") {
                subCategory.category = selectedCategory
                let newSubCategory = subCategory
                didAddSubCategory(newSubCategory)
            }
        }
        
    }
}

//struct EditSubCategoryDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSubCategoryDetailsView()
//    }
//}
