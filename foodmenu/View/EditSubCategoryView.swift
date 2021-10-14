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
    
    func move(from source: IndexSet, to destination: Int) {
        mainMenu.subCategories.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        HStack {
            TextField("Subcategory Name", text: $newSubCategory)
            Button(action: {
                withAnimation(.easeIn) {
                    mainMenu.insertSubCategory(subCategory: SubCat(name: newSubCategory, category: ""))
                    newSubCategory = ""
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .accessibilityLabel(Text("Add category"))
            }
            .buttonStyle(GrowingButton())
            .foregroundColor(newSubCategory.isEmpty ? .orange.opacity(0.5) : .orange)
            .disabled(newSubCategory.isEmpty)
        }
        ForEach(mainMenu.subCategories, id:\.self) { subcategory in
            HStack {
                Text(subcategory.name)
                if subcategory.category.isEmpty {
                    Text("No category assigned")
                        .font(.caption2)
                        .fontWeight(.light)
                } else {
                    Text(subcategory.category)
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
                        .foregroundColor(editMode == .inactive ? .orange.opacity(0.5) : .orange)
                }
//                .padding(.trailing)
                .buttonStyle(GrowingButton())
                .disabled(editMode == .inactive)
            }
        }
        .onMove(perform: move)
        .onDelete { indices in
            mainMenu.subCategories.remove(atOffsets: indices)
            mainMenu.deleteSubCategory()
        }
        .sheet(isPresented: $editSubCategotyDetails) {
            EditSubCategoryDetailsView(mainMenu: mainMenu, subCategory: $selectedSubCategory) { addedSubCategory in
                mainMenu.insertSubCategory(subCategory: addedSubCategory)
                mainMenu.updateItemCategory(newName: addedSubCategory.name, oldName: selectedSubCategory.name)
                editSubCategotyDetails = false
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
