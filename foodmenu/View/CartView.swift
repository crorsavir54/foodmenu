//
//  CartView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/23/21.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cart: CartViewModel
    
    @State var itemNumber = 1.0
    
    var body: some View {
        VStack (alignment: .leading) {
                Text("My Cart")
                    .fontWeight(.bold)
                    .font(.largeTitle)
            ForEach(cart.cart.items.unique(), id:\.self) { item in
                    HStack {
                        Image(item.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100, alignment: .leading)
                        VStack(alignment: .leading) {
                            Text("\(item.name) x \(cart.itemNumber(item: item), specifier: "%.0f")")
                                .font(.body)
                            HStack(spacing: 2){
                                Text("$")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                Text("\(item.price*cart.itemNumber(item: item), specifier: "%.2f")")
                                    .fontWeight(.semibold)
                                Spacer()
                                HStack {
                                    Button(action: {cart.removeItem(item: item)}, label: {
                                        Image(systemName: "minus.circle")
                                    })
                                    Button(action: {cart.incrementItem(item: item)}, label: {
                                        Image(systemName: "plus.circle")
                                    })
                                }.foregroundColor(.orange)
                            }
                        }
                        Spacer()
                    }
                    Divider()
                }
            Text("Total: $\(cart.total, specifier: "%.2f")")
                .fontWeight(.bold)
            HStack {
                Spacer()
                Button(action: {
                    // TODO: Toggle order summary sheet, and make order
    //                isCartPresented.toggle()
                    print("Show Order Confirmation")
                }, label: {
                    Text("Order")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.size.width/2, height: 55, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.orange))
                }).buttonStyle(GrowingButton())
                    .padding()
                    .clipped()
                    .shadow(color: Color.black.opacity(0.15),
                            radius: 3,
                            x: 3,
                            y: 3)
                Spacer()
            }
            Spacer()
            }.padding()
            
            


        

    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(cart: CartViewModel(cart: Cart(items: [], note: "")))
    }
}
