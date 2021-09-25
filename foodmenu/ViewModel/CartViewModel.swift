//
//  CartViewModel.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/25/21.
//

import Foundation

struct Cart: Hashable {
    var items: [CatItem]
    var note: String
    init(items: [CatItem], note: String) {
        self.items = items
        self.note = note
    }
}

class CartViewModel: ObservableObject {
    
    @Published var cart: Cart
    
    init(cart: Cart) {
        self.cart = cart
        
        self.cart.note = "Basta amo na note ini nako"
        self.cart.items = [CatItem(subcategory: "soda", name: "Coke", description: "Itom na tubig", price: 5.99),
                           CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na ga bula2", price: 5.99),
                           CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na ga bula2", price: 5.99)]
    }
    
    var total: Double {
        cart.items.lazy.map{ $0.price }.reduce(0.0,+)
    }
    var itemNames: [String] {
        cart.items.map{$0.name}
    }

    func itemNumber(item: CatItem) -> Double {
        return Double(cart.items.filter {$0 == item}.count)
    }

    func incrementItem(item: CatItem) {
        cart.items.append(item)
    }
    
    func removeItem(item: CatItem) {
        if let index = cart.items.firstIndex(of: item) {
            cart.items.remove(at: index)
        }
    }
    
    
}
