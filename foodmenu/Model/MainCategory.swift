//
//  MainCategory.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import FirebaseFirestoreSwift

struct MainCategory: Hashable, Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var icon: String = ""
    var userId: String?
}
