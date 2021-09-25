//
//  Array+RemoveDuplicates.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/25/21.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
