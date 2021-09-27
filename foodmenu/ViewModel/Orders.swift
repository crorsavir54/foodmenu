//
//  Orders.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/27/21.
//

import Foundation
import SwiftUI

struct Order: Hashable, Identifiable {
    var id = UUID()
    var order: Cart
    var status: OrderStatus
    enum OrderStatus: CaseIterable {
        case pending
        case cancelled
        case fullfilled
    }
}

class Orders: ObservableObject {
    //    @ObservedObject var cart = CartViewModel(cart: Cart(items: [], note: ""))
    @Published var orders = [Order]()
    
//    init() {
////        orders.append(Order(order: Cart(items: [CatItem(subcategory: "soda", name: "Coke", description: "Itom na tubig", price: 5.99), CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na may bura-bura", price: 5.99)],
////                                        note: "Wara"), status: .pending))
////        orders.append(Order(order: Cart(items: [CatItem(subcategory: "soda", name: "Coke", description: "Itom na tubig", price: 5.99), CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na may bura-bura", price: 5.99)],
////                                        note: "Wara"), status: .pending))
////        orders.append(Order(order: Cart(items: [CatItem(subcategory: "talong", name: "talong", description: "basta", price: 2.99), CatItem(subcategory: "soda", name: "Sprite", description: "Tubig na may bura-bura", price: 5.99)],
////                                        note: "Wara"), status: .fullfilled))
//    }
    func itemNumber(order: Order, item: CatItem) -> Double {
        if let index = orders.firstIndex(where: {$0.id == order.id}) {
            let selectedOrder  = orders[index]
            let itemsToFilter = selectedOrder.order.items
            return Double(itemsToFilter.filter{$0 == item}.count)
        } else {
            return 0.0
        }
    }
    
    func pendingCount() -> Int {
        return orders.filter{$0.status == .pending}.count
    }
    
    func addOrder(order: Order) {
        if !order.order.items.isEmpty {
            if let index = orders.firstIndex(where: {$0.id == order.id}) {
                    orders[index] = order
                    print("Updated order info")
                
            } else {
                orders.append(order)
                print("Added new order")
            }
        } else {
            print("Empty cart")
        }
    }
    
    func changeOrderStatus(order: Order, status: Order.OrderStatus) {
        if let index = orders.firstIndex(where: {$0.id == order.id}) {
            orders[index].status = status
        } else {
            print("Cannot find order to update")
        }
    }
    
    
    func removeOrder(order: Order) {
        if let index = orders.firstIndex(where: {$0.id == order.id}) {
            orders.remove(at: index)
        } else {
            print("Cannot find order to delete")
        }
    }
    
}
