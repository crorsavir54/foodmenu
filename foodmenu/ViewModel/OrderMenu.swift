//
//  OrderMenu.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//
import Foundation
import SwiftUI
import Combine
import FirebaseFirestoreSwift

//struct MainCategory: Hashable, Identifiable, Codable{
//    @DocumentID var id: String?
//    var name: String
//    var icon: String = ""
//}



//struct subCategory

class OrderMenu: ObservableObject {
    
    @Published var categoryRepository = CategoryRepository()
    @Published var categories = [MainCategory]()
    private var cancellables: Set<AnyCancellable> = []
    
    func insertCategory(category: MainCategory) {
        if categories.firstIndex(where: {$0.id == category.id}) != nil {
            categoryRepository.update(category)
        } else {
            categoryRepository.add(category)
        }
    }
    //    func deleteCategory(category: MainCategory) {
    //        if let index = categories.firstIndex(of: category) {
    //            categories.remove(at: index)
    //            categoryRepository.remove(category)
    //        }
    //    }
        
    func deleteCategory() {
        let deletedCategories = categories.difference(from: categoryRepository.mainCategories)
        for category in deletedCategories {
            categoryRepository.remove(category)
        }

    }
    
    
    @Published var subCategoryRepository = SubCategoryRepository()
    @Published var subCategories = [SubCat]()
    private var subCategoryCancellables: Set<AnyCancellable> = []
    
    func insertSubCategory(subCategory: SubCat) {
        if subCategories.firstIndex(where: {$0.id == subCategory.id}) != nil {
            subCategoryRepository.update(subCategory)
        } else {
            subCategoryRepository.add(subCategory)
        }
    }
    
//    func insertSubCategory(subCategory: SubCat) {
//        if let index = subCategories.firstIndex(where: {$0.id == subCategory.id}){
//            subCategories[index] = subCategory
//        } else {
//            subCategories.append(subCategory)
//        }
//    }
//
    func deleteSubCategory() {
        let deletedSubCategories = subCategories.difference(from: subCategoryRepository.subCategories)
        for subcategory in deletedSubCategories {
            subCategoryRepository.remove(subcategory)
        }
    }
    
    @Published var itemRepository = ItemRepository()
    @Published var items = [CatItem]()
    private var itemCancellables: Set<AnyCancellable> = []
    
    func insertItem(item: CatItem) {
        if items.firstIndex(where: {$0.id == item.id}) != nil {
            itemRepository.update(item)
        } else {
            itemRepository.add(item)
        }
    }
    
    func deleteItem() {
        let deletedItems = items.difference(from: itemRepository.items)
        for item in deletedItems {
            itemRepository.remove(item)
        }
    }
    
    // Log in and Log out and reset view
    func logOut() {
        categories.removeAll()
    }
    
    func logIn() {
        categories.removeAll()
        categoryRepository.$mainCategories
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)
        subCategoryRepository.$subCategories
            .assign(to: \.subCategories, on: self)
            .store(in: &subCategoryCancellables)
        itemRepository.$items
            .assign(to: \.items, on: self)
            .store(in: &itemCancellables)
    }
    
    init(){
        categoryRepository.$mainCategories
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)
        subCategoryRepository.$subCategories
            .assign(to: \.subCategories, on: self)
            .store(in: &subCategoryCancellables)
        itemRepository.$items
            .assign(to: \.items, on: self)
            .store(in: &itemCancellables)
//        if categoryRepository.mainCategories.isEmpty {
//            insertCategory(category: MainCategory(name: "Main", icon: "🍽"))
//            insertCategory(category: MainCategory(name: "Breakfast", icon: "🍳"))
//            insertCategory(category: MainCategory(name: "Beverage", icon: "🥤"))
//        }
        //Dummy Main Categories
//        categories.append(MainCategory(name: "Main", icon: "🍽"))
//        categories.append(MainCategory(name: "Breakfast", icon: "🍳"))
//        categories.append(MainCategory(name: "Beverage", icon: "🥤"))
        
        //Dummy Sub Categories
//        subCategories.append(SubCat(name: "kaldereta", color: .red, category: "Main"))
//        subCategories.append(SubCat(name: "talong", color: .green, category: "Main"))
//        subCategories.append(SubCat(name: "kornbep", color: .blue, category: "Main"))
//        subCategories.append(SubCat(name: "itlog", color: .yellow, category: "Breakfast"))
//        subCategories.append(SubCat(name: "tosino", color: .yellow, category: "Breakfast"))
//        subCategories.append(SubCat(name: "soriso", color: .yellow, category: "Breakfast"))
//        subCategories.append(SubCat(name: "hatdog", color: .yellow, category: "Breakfast"))
//        subCategories.append(SubCat(name: "soda", color: .yellow, category: "Beverage"))
//
//
        //Dummy Items
//        items.append(CatItem(subcategory: "itlog", name: "omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99))
//        items.append(CatItem(subcategory: "itlog", name: "omelette2", description: "Itlog na gi batil, tas gi prito? na may gulay gamay na gi roll", price: 5.99))
//        items.append(CatItem(subcategory: "itlog", name: "omelette3", description: "Itlog na gi batil, tas gi prito?", price: 3.99))
//        items.append(CatItem(subcategory: "talong", name: "talong", description: "Talong na may itlog", price: 125.99,
//                             inStock: false))
//
//        items.append(CatItem(subcategory: "soda", name: "Coke", description: "Itom na tubig", price: 5.99))
//        items.append(CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na may bura-bura", price: 5.99))
    }
    
    // MARK: - Intents
    
    func returnCategoryName(name: String) -> String {
        if let categoryname = subCategories.first(where: {$0.name == name}) {
            return categoryname.category
        }
        return ""
    }
    
    func allCategories() -> [String] {
        var allCategories = [String]()
        for category in categories {
            allCategories.append(category.name)
        }
        return allCategories
    }
    
    func allSubCategories() -> [String] {
        var allSubCategories = [String]()
        for category in subCategories {
            allSubCategories.append(category.name)
        }
        return allSubCategories
    }

    func allItems(subCategory: SubCat) -> [CatItem] {
        return items.filter{$0.subcategory == subCategory.name}
    }
    
    func allSubCategeries(category: MainCategory) -> [SubCat] {
        return subCategories.filter{$0.category == category.name}
    }
    

    

    

    
    
}
