//
//  CatItem.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/29/21.
//
import FirebaseFirestoreSwift

struct CatItem: Hashable, Identifiable, Codable{
    @DocumentID var id: String?
    var subcategory: String = "none"
    var name: String
    var description: String
    var price = 0.0
    var inStock: Bool = true
    var userId: String?
    var imageUrl: String = ""
}
