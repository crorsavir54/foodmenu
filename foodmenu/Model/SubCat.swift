//
//  SubCat.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import FirebaseFirestoreSwift

struct SubCat: Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String
}
