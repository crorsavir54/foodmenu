//
//  Orders.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/27/21.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Combine

enum OrderStatus: String, Codable {
    case pending
    case cancelled
    case fullfilled
}


class Orders: ObservableObject {
    //    @ObservedObject var cart = CartViewModel(cart: Cart(items: [], note: ""))
    @ObservedObject var orderRepository = OrderRepository()
    @Published var orders = [Order]()
    private var cancellables: Set<AnyCancellable> = []
    
    func addOrder(order: Order) {
        if !order.order.items.isEmpty {
            if orders.firstIndex(where: {$0.id == order.id}) != nil {
                orderRepository.update(order)
            } else {
                orderRepository.add(order)
            }
            
        } else {
            print("Cart Empty")
        }
    }

    func deleteCategory() {
        let deletedOrder = orders.difference(from: orderRepository.orders)
        for order in deletedOrder {
            orderRepository.remove(order)
        }
    }
    
    func changeOrderStatus(order: Order, status: OrderStatus) {
        if orders.firstIndex(where: {$0.id == order.id}) != nil {
            var updated = order
            updated.status = status
            updated.id = order.id
            orderRepository.update(updated)
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
    
    init() {
        orderRepository.$orders
            .assign(to: \.orders, on: self)
            .store(in: &cancellables)
    }

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
    

    
}
