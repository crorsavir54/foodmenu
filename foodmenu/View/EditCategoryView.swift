//
//  EditMenuView.swift
//  foodmenu
//
//  Created by corivπ§π»βπ» on 9/24/21.
//

import SwiftUI

struct EditCategoryView: View {
    
    @ObservedObject var mainCategories: OrderMenu
    @State var selectedCategory: MainCategory = MainCategory(name: "Main", icon: "π½")
    @State var selectedCategoryEdited: MainCategory = MainCategory(name: "Main", icon: "π½")
    @State var isCategoryDetailPresented = false
    @State var editMode: EditMode = .inactive
    @State private var newCategory = ""
    @State private var newCategoryIcon = ""
    
    func move(from source: IndexSet, to destination: Int) {
        mainCategories.categories.move(fromOffsets: source, toOffset: destination)
    }
    
    var body: some View {
        List {
            Section(header: Text("Main Categories")) {
                HStack {
                    TextField("Category Name", text: $newCategory)
                    Divider()
                    TextField("Icon", text: $newCategoryIcon)
                    
                    Button(action: {
                        withAnimation(.easeIn) {
                            mainCategories.insertCategory(category: MainCategory(name: newCategory, icon: newCategoryIcon))
                            newCategory = ""
                            newCategoryIcon = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(Text("Add category"))
                            .font(.title2)
                    }
                    .buttonStyle(GrowingButton())
                    .foregroundColor(newCategory.isEmpty||newCategoryIcon.isEmpty ? .orange.opacity(0.5) : .orange)
                    .disabled(newCategory.isEmpty||newCategoryIcon.isEmpty)
                }
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
                .onMove(perform: move)
                .onDelete { indices in
                    mainCategories.categories.remove(atOffsets: indices)
                    mainCategories.deleteCategory()
                }
                

            }
            Section(header: Text("Sub Categories")) {
                EditSubCategoryView(mainMenu: mainCategories, editMode: $editMode)
            }
            
        }
        .toolbar {
            ToolbarItem{EditButton()}
        }
        .environment(\.editMode, $editMode)
        .listStyle(SidebarListStyle())
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
        EditCategoryView(mainCategories: OrderMenu(), selectedCategory: MainCategory(name: "Main", icon: "π½"))
    }
}
