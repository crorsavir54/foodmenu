//
//  Categories.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/17/21.
//

import SwiftUI
import Foundation

struct Categories: Hashable {
    
    struct Category: Hashable {
        var icon: String
        var name: String
        var color: Color
    }
    
    static var main = Category(icon: "🍛", name: "Main", color: .green)
    static var breakfast = Category(icon: "🍳", name: "Breakfast", color: .purple)
    static var appetizer = Category(icon: "🍧", name: "Appetizer", color: .blue)
    static var beverage = Category(icon: "🧋", name: "Beverage", color: .red)
    static var sideDish = Category(icon: "🧀", name: "Side Dish", color: .orange)
    
    static var categories = [main, breakfast, appetizer,beverage,sideDish]
    
    struct SubCategory: Hashable {
        var imageName: String
        var name: String
        var color: Color
        var image: Image {
            Image(imageName)
        }
    }
    
    static var kaldereta = SubCategory(imageName: "kaldereta", name: "Kaldereta", color: .green)
    static var talong = SubCategory(imageName: "kaldereta", name: "Talong", color: .purple)
    static var kornbep = SubCategory(imageName: "kaldereta", name: "Kornbep", color: .blue)
    static var basta = SubCategory(imageName: "kaldereta", name: "Basta", color: .orange)
    
    static var subCategories = [kaldereta, talong, kornbep, basta]
}
