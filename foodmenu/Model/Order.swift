//
//  Order.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Order: Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var order: Cart
    var status: OrderStatus
    var userId: String?
}
