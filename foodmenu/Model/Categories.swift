//
//  Categories.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/17/21.
//

import SwiftUI
import Foundation

struct Restaurant: Hashable {
    
    struct Category: Hashable {
        var icon: String
        var name: String
        var color: Color
        var subcategories: [SubCategory]
    }
    
    static var main = Category(icon: "🍛", name: "Main", color: .green, subcategories: SubCategory.mainSubCategories)
    static var breakfast = Category(icon: "🍳", name: "Breakfast", color: .purple, subcategories: SubCategory.breakFastSubCategories)
    static var appetizer = Category(icon: "🍧", name: "Appetizer", color: .blue, subcategories: SubCategory.mainSubCategories)
    static var beverage = Category(icon: "🧋", name: "Beverage", color: .red, subcategories: SubCategory.breakFastSubCategories)
    static var sideDish = Category(icon: "🧀", name: "Side Dish", color: .orange, subcategories: SubCategory.mainSubCategories)
    
    static var categories = [main, breakfast, appetizer,beverage,sideDish]
}

struct SubCategory: Hashable {

    var imageName: String
    var name: String
    var color: Color
    var image: Image {
        Image(imageName)
    }
    
    var items: [Item] {
        return Item.items.filter{$0.subCategoryName == self.name}
        
    }

    static var beef = SubCategory(imageName: "kaldereta", name: "Beef", color: .green)
    static var talong = SubCategory(imageName: "talong", name: "Talong", color: .purple)
    static var kornbep = SubCategory(imageName: "kornbep", name: "Kornbep", color: .blue)
    static var basta = SubCategory(imageName: "kaldereta", name: "Basta", color: .orange)

    static var itlog = SubCategory(imageName: "itlog", name: "Itlog", color: .green)
    static var tosino = SubCategory(imageName: "tosino", name: "Tosino", color: .purple)
    static var soriso = SubCategory(imageName: "soriso", name: "Soriso", color: .blue)
    static var hatdog = SubCategory(imageName: "hatdog", name: "Hatdog", color: .red)
    static var hatdog2 = SubCategory(imageName: "hatdog", name: "Hatdog2", color: .red)
    static var hatdog3 = SubCategory(imageName: "hatdog", name: "Hatdog3", color: .red)
    static var hatdog4 = SubCategory(imageName: "hatdog", name: "Hatdog3", color: .pink)

    static var mainSubCategories = [beef, talong, kornbep, basta]
    static var breakFastSubCategories = [itlog, tosino, soriso, hatdog, hatdog2, hatdog3, hatdog4]

}

struct Item: Hashable {
    var subcategory: SubCategory
    var name: String
    var description: String
    var price = 0.0
    var imageName: String
    
    var image: Image {
        Image(imageName)
    }
    var subCategoryName: String {
        subcategory.name
    }
    
    static var omelette = Item(subcategory: SubCategory.itlog, name: "Omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99, imageName: "omelette")
    static var omelette2 = Item(subcategory: SubCategory.itlog, name: "Omelette2", description: "Itlog na gi batil, tas gi prito? na may gulay gamay na gi roll", price: 5.99, imageName: "omelette2")
    static var omelette3 = Item(subcategory: SubCategory.itlog, name: "Omelette3", description: "Itlog na gi batil, tas gi prito?", price: 3.99, imageName: "omelette3")
    static var tortangTalong = Item(subcategory: SubCategory.talong, name: "Tortang Talong", description: "Talong na may itlog", price: 125.99, imageName: "talong")
    
    static var items = [omelette, omelette2, omelette3, tortangTalong]
}

//struct Cart: Hashable {
//    var items: [Item]
//    var note: String
//    var total: Double {
//        items.lazy.map{$0.price}.reduce(0.0,+)
//    }
//    var itemNames: [String] {
//        items.map{$0.name}
//    }
//    
//    static var cart1 = Cart(items: [Item.omelette, Item.omelette2], note: "This is my dummy cart")
//    static var carts = [cart1]
//}
