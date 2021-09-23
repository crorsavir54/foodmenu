//
//  CartView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/23/21.
//

import SwiftUI

struct CartView: View {
    
    @State var cart = Cart.cart1
    
    var body: some View {
        
        VStack {
            List {
                ForEach(cart.items, id:\.self) { item in
                    HStack {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .leading)
                        Text(item.name)
                        Text("\(item.price, specifier: "%.2f")")
                    }
                }
            }.padding()

        }
        

    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
