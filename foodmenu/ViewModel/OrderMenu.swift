//
//  OrderMenu.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//
import Foundation
import SwiftUI


struct MainCategory: Hashable {
    var name: String
    var icon: String
}

struct SubCat: Hashable {
    var name: String
    var color: Color
    var category: String = "none"
    var image: Image {
        Image(name)
    }
}

struct CatItem: Hashable {
    var subcategory: String = "none"
    var name: String
    var description: String
    var price = 0.0
    var image: Image {
        Image(name)
    }
}

//struct subCategory

class OrderMenu: ObservableObject {
    
    @Published var categories = [MainCategory]() {
        didSet {
            if categories.isEmpty {
                categories.append(MainCategory(name: "Main", icon: "🍽"))
                categories.append(MainCategory(name: "Breakfast", icon: "🍳"))
                categories.append(MainCategory(name: "Bevarage", icon: "🥤"))
            }
        }
    }
    
    @Published var subCategories = [SubCat]()
    
    @Published var items = [CatItem]()
    
    init(){
        
        //Dummy Main Categories
        categories.append(MainCategory(name: "Main", icon: "🍽"))
        categories.append(MainCategory(name: "Breakfast", icon: "🍳"))
        categories.append(MainCategory(name: "Beverage", icon: "🥤"))
        
        //Dummy Sub Categories
        subCategories.append(SubCat(name: "kaldereta", color: .red, category: "Main"))
        subCategories.append(SubCat(name: "talong", color: .green, category: "Main"))
        subCategories.append(SubCat(name: "kornbep", color: .blue, category: "Main"))
        subCategories.append(SubCat(name: "itlog", color: .yellow, category: "Breakfast"))
        subCategories.append(SubCat(name: "tosino", color: .yellow, category: "Breakfast"))
        subCategories.append(SubCat(name: "soriso", color: .yellow, category: "Breakfast"))
        subCategories.append(SubCat(name: "hatdog", color: .yellow, category: "Breakfast"))
        subCategories.append(SubCat(name: "soda", color: .yellow, category: "Beverage"))
        
        
        //Dummy Items
        items.append(CatItem(subcategory: "itlog", name: "omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99))
        items.append(CatItem(subcategory: "itlog", name: "omelette2", description: "Itlog na gi batil, tas gi prito? na may gulay gamay na gi roll", price: 5.99))
        items.append(CatItem(subcategory: "itlog", name: "omelette3", description: "Itlog na gi batil, tas gi prito?", price: 3.99))
        items.append(CatItem(subcategory: "talong", name: "talong", description: "Talong na may itlog", price: 125.99))
        
        items.append(CatItem(subcategory: "soda", name: "Coke", description: "Itom na tubig", price: 5.99))
        items.append(CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na may bura-bura", price: 5.99))
    }
    
    // MARK: - Intents
    
    func allItems(subCategory: SubCat) -> [CatItem] {
        return items.filter{$0.subcategory == subCategory.name}
    }
    
    func allSubCategeries(category: MainCategory) -> [SubCat] {
        return subCategories.filter{$0.category == category.name}
    }
    
    func insertCategory(category: MainCategory) {
        if let index = categories.firstIndex(of: category) {
            categories[index] = category
        } else {
            categories.append(category)
        }
    }
    
    func deleteCategory(category: MainCategory) {
        if let index = categories.firstIndex(of: category) {
            categories.remove(at: index)
        }
    }
    
    func insertSubCategory(subCategory: SubCat) {
        if let index = subCategories.firstIndex(of: subCategory) {
            subCategories[index] = subCategory
        } else {
            subCategories.append(subCategory)
        }
    }
    
    func deleteCategory(subCategory: SubCat) {
        if let index = subCategories.firstIndex(of: subCategory) {
            subCategories.remove(at: index)
        }
    }
}
