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
    @State private var newCategory = ""
    @State private var newCategoryIcon = ""
    
    
    var body: some View {
        List {
            Section(header: Text("Main Categories")) {
                ForEach(mainCategories.categories, id:\.self) { category in
                    HStack {
                        Text(category.name)
                        Text(category.icon)
                    }
                    .onTapGesture {
                        selectedCategory = category
                        isCategoryDetailPresented.toggle()
                    }
                }.onDelete { indices in
                    mainCategories.categories.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Category Name", text: $newCategory)
                    Divider()
                    TextField("Icon", text: $newCategoryIcon)
//                    TextField("New Categoty Icon", text: $newCategory)
                    Button(action: {
                        withAnimation {
                            mainCategories.insertCategory(category: MainCategory(name: newCategory, icon: newCategoryIcon))
//                            mainCategories..append(newCategory)
                            newCategory = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add category"))
                    }
                    .disabled(newCategory.isEmpty||newCategoryIcon.isEmpty)
                }
            }
            .listStyle(InsetGroupedListStyle())
            }
//            .sheet(isPresented: $isCategoryDetailPresented, onDismiss: didDismiss) {
////            EditCategoryDetailView(category: $selectedCategoryEdited)
        }
    }
    
//    func didDismiss() {
//        if selectedCategory != selectedCategoryEdited {
//            mainCategories.insertCategory(category: selectedCategoryEdited)
//        }
//    }
//}

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(mainCategories: OrderMenu(), selectedCategory: MainCategory(name: "Main", icon: "🍽"))
    }
}
