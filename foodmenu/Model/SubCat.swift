//
//  SubCat.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import FirebaseFirestoreSwift
import Foundation

struct SubCat: Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var userId: String?
    var imageUrl: String = ""
}
