//
//  EditSubCategoryView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditSubCategoryView: View {
    @ObservedObject var mainMenu: OrderMenu
    @Binding var editMode: EditMode
    @State private var newSubCategory = ""
    @State var editSubCategotyDetails = false
    @State var selectedSubCategory = SubCat(name: "", category: "")
    
    var body: some View {
        
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
            ForEach(mainMenu.subCategories, id:\.self) { subcategory in

                HStack {
                    Text(subcategory.name)
                        .padding(.leading)
                    if subcategory.category.isEmpty {
                        Text("No category assigned")
                            .font(.caption2)
                            .fontWeight(.light)
                    }
                    Spacer()
                    Button(action: {
                        selectedSubCategory = subcategory
                        editSubCategotyDetails.toggle()
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(editMode == .inactive ? Color.clear : .orange)

                    }
                    .padding(.trailing)
                    .buttonStyle(GrowingButton())
                    .disabled(editMode == .inactive)
                }
                
            }.onDelete { indices in
                mainMenu.subCategories.remove(atOffsets: indices)
            }

            //                    }
        .sheet(isPresented: $editSubCategotyDetails) {
            EditSubCategoryDetailsView(mainMenu: mainMenu, subCategory: $selectedSubCategory) { addedSubCategory in
                mainMenu.insertSubCategory(subCategory: addedSubCategory)
                editSubCategotyDetails.toggle()
                print("added subcategory id is: \(addedSubCategory.id)")
                print("selected subcategory id is: \(selectedSubCategory.id)")
            }
        }
        .environment(\.editMode, $editMode)
        
    }
}

struct EditSubCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditSubCategoryView(mainMenu: OrderMenu(), editMode: .constant(.active
                                                                      ))
    }
}
