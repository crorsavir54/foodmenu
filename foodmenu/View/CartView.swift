//
//  CartView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/23/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var cartView: CartViewModel
    @ObservedObject var orderViewModel: Orders
    @Environment(\.presentationMode) var presentationMode
    
    @State var itemNumber = 1.0
    
    var body: some View {
        VStack (alignment: .leading) {
            if cartView.cart.items.isEmpty {
                VStack {
                    Spacer()
                    HStack(alignment: .center){
                        Spacer()
                        VStack(alignment: .center) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Nothing Here")
                            Text("Add items to your cart now")
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Text("My Cart")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                    ForEach(cartView.cart.items.removingDuplicates(), id:\.self) { item in
                        HStack {
                            AnimatedImage(url: URL(string: item.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .frame(width: 100, height: 100, alignment: .leading)
                            VStack(alignment: .leading) {
                                Text("\(item.name) x \(cartView.itemNumber(item: item), specifier: "%.0f")")
                                    .font(.body)
                                HStack(spacing: 2){
                                    Text("$")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                    Text("\(item.price*cartView.itemNumber(item: item), specifier: "%.2f")")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    HStack {
                                        Button(action: {cartView.removeItem(item: item)}, label: {
                                            Image(systemName: "minus.circle")
                                        })
                                        Button(action: {cartView.incrementItem(item: item)}, label: {
                                            Image(systemName: "plus.circle")
                                        })
                                    }.foregroundColor(.orange)
                                }
                            }
                            Spacer()
                        }
                        Divider()
                    }
                    Text("Total: $\(cartView.total, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
                
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        orderViewModel.addOrder(order: Order(order: cartView.cart, status: .pending))
                        cartView.clearCart()
                        presentationMode.wrappedValue.dismiss()
                    }
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
        }.padding()
        
        
        
        
        
        
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(cartView: CartViewModel(cart: Cart(items: [], note: "")), orderViewModel: Orders())
    }
}
