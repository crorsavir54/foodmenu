//
//  EditItemsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/24/21.
//

import SwiftUI

struct EditItemsView: View {
    @ObservedObject var mainMenu: OrderMenu
    
    var body: some View {
        List {
            ForEach(mainMenu.items, id:\.self) { item in
                HStack {
                    Image(item.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .fontWeight(.semibold)
                        Text(item.description)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct EditItemsView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemsView(mainMenu: OrderMenu())
    }
}
