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
        NavigationView {
            List {
                Section() {
                    Picker("Categories", selection: $selectedCategory) {
                        ForEach(mainMenu.allCategories(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.inline)
                }
            }
            .navigationTitle("Assign Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        let newSubCategory = subCategory
                        didAddSubCategory(newSubCategory)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        subCategory.category = selectedCategory
                        let newSubCategory = subCategory
                        didAddSubCategory(newSubCategory)
                    }
                    
                }
            }


        }

        .onAppear {
            selectedCategory = subCategory.category
        }
        
    }
}

//struct EditSubCategoryDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSubCategoryDetailsView()
//    }
//}
