//
//  Cart.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/30/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Cart: Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var items: [CatItem]
    var note: String
    var userId: String?
    
    init(items: [CatItem], note: String) {
        self.items = items
        self.note = note
    }
    
}
