//
//  EditSubCategoryView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditSubCategoryView: View {
    @ObservedObject var mainMenu: OrderMenu
    @State var editMode: EditMode = .inactive
    @State private var newSubCategory = ""
    @State var editSubCategotyDetails = false
    @State var selectedSubCategory = SubCat(name: "", category: "")
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mainMenu.subCategories, id:\.self) { subcategory in
                    HStack {
                        Text(subcategory.name)
                    }
                    .onTapGesture {
                        selectedSubCategory = subcategory
                        editSubCategotyDetails.toggle()
                    }
                    
                }
                HStack {
                    TextField("New SubCatery Name", text: $newSubCategory)
                    Button(action: {
                        withAnimation {
                            mainMenu.insertSubCategory(subCategory: SubCat(name: newSubCategory, category: ""))
                            //                            mainCategories..append(newCategory)
                            newSubCategory = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add category"))
                    }
                    .disabled(newSubCategory.isEmpty)
                }
                //                    }
                
            }
            .sheet(isPresented: $editSubCategotyDetails) {
                EditSubCategoryDetailsView(mainMenu: mainMenu, subCategory: $selectedSubCategory) { addedSubCategory in
                    mainMenu.insertSubCategory(subCategory: addedSubCategory)
                    editSubCategotyDetails.toggle()
                    print("added subcategory id is: \(addedSubCategory.id)")
                    print("selected subcategory id is: \(selectedSubCategory.id)")
                }
            }
            //            .toolbar {
            //                ToolbarItem{EditButton()}
            //            }
            //            .environment(\.editMode, $editMode)
        }
    }
}

struct EditSubCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditSubCategoryView(mainMenu: OrderMenu())
    }
}
