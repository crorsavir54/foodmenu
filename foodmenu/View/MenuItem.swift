//
//  MenuItem.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/21/21.
//

import SwiftUI

struct MenuItem: View {
    @ObservedObject var items = OrderMenu()
    @ObservedObject var cart: CartViewModel
    @Binding var subCategory: SubCat
    @State var selectedItem: CatItem
    @State var tabNames = ["All", "New", "Popular", "New Items"]
//    @State var cart = Cart.cart1
    
    func allItems() -> [CatItem] {
        return items.allItems(subCategory: subCategory)
    }
    
    let columns = [
        GridItem(.flexible(minimum: 40), spacing: 10)
    ]
    
    var body: some View {
        
        GeometryReader { geometry in
            if !allItems().isEmpty {
                VStack {
                    HStack {
                        Button(action: {}, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(lineWidth: 0.5, antialiased: true)
                                    .foregroundColor(.orange)
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                            }.frame(width: geometry.size.width/7, height: geometry.size.width/7)
                        }).foregroundColor(.orange)
                        Spacer()
                        Text(subCategory.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {}, label: {
                            Image(systemName: "square.grid.2x2")
                                .font(.title2)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                        }).foregroundColor(.orange)
                        
                    }
                    
                    .padding(.leading)
                    .padding(.trailing)
                    LazyHGrid(rows: [GridItem(.fixed(20))], alignment: .center, spacing: 20) {
                        ForEach(tabNames, id:\.self) { name in
                            Text(name)
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    .frame(minWidth: geometry.size.width, maxHeight: 50 ,alignment: .leading)
                    HStack (alignment: .top) {
                        ScrollView {
                            LazyVGrid(columns: columns, alignment: .leading) {
                                ForEach(items.allItems(subCategory: subCategory), id:\.self) { item in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .stroke(lineWidth: 0.1)
                                            .opacity(selectedItem.name == item.name ? 0 : 0.5)
                                            .frame(width: geometry.size.width/4.5, height: geometry.size.width/4.5)
                                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                                            .fill(Color.gray)
                                            .opacity(selectedItem.name == item.name ? 0.2 : 0)
                                            .frame(width: geometry.size.width/4.5, height: geometry.size.width/4.5)
                                        
                                        Image(item.name)
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                            .frame(width: geometry.size.width/3.8, height: geometry.size.width/3.8, alignment: .leading)
                                    }
                                    .onTapGesture {
                                        withAnimation(){
                                            selectedItem = item
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width/3)
                        Divider()
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Image(selectedItem.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width/2, height: geometry.size.width/2, alignment: .leading)
                            HStack {
                                Text(selectedItem.name)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                            }
                            HStack(alignment: .top) {
                                Text("$")
                                    .foregroundColor(.orange)
                                    .fontWeight(.black)
                                Text("\(selectedItem.price, specifier: "%.2f")")
                                    .foregroundColor(.orange)
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                            }
                            VStack {
                                ScrollView {
                                    Text(selectedItem.description)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: geometry.size.width/2, height: 120, alignment: .topLeading)
                            }
//                            HStack {
//                                HStack {
//                                    Spacer()
//                                    Button(action: {}) {
//                                        Image(systemName: "minus.circle.fill")
//                                            .foregroundColor(.orange)
//                                            .font(.title)
//                                    }
//                                    Text("1")
//                                        .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
//                                        .overlay(RoundedRectangle(cornerRadius: 10)
//                                                    .stroke(Color.orange, lineWidth: 2))
//                                    Button(action: {}) {
//                                        Image(systemName: "plus.circle.fill")
//                                            .foregroundColor(.orange)
//                                            .font(.title)
//                                    }
//                                    Spacer()
//                                }
//
//                            }.padding(.bottom)
                        }
                        .frame(width: geometry.size.width/2, alignment: .leading)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        Button(action: {}) {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width/2-30, height: 50)
                                Rectangle()
                                    .foregroundColor(.orange).opacity(0.2)
                                    .frame(width: geometry.size.width/2-30, height: 50)
                                VStack (alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Text("\(cart.cart.items.count)")
                                        Text(" items")
                                            .font(.system(size: 10))
                                        Text("|")
                                            .fontWeight(.thin)
                                            .padding(.leading, 5)
                                            .padding(.trailing)
                                        Text("$ ")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                        Text("\(cart.total, specifier: "%.2f")")
                                            .fontWeight(.semibold)
                                            .font(.callout)
                                        
                                    }
                                    Text("Extra charges may apply")
                                        .font(.system(size: 10))
                     
                                }.padding(.leading,30)
                            }
                        }.foregroundColor(.orange)
                        Button(action: {cart.incrementItem(item: selectedItem)}) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.orange)
                                    .frame(width: geometry.size.width/2-40, height: 50)
                                HStack {
                                    Text("Add to order")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right")
                                }
                            }
                        }.foregroundColor(.white)
                    }
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.2),
                            radius: 3,
                            x: 1,
                            y: 3)
                }
                .padding(.top)
                
            } else {
                VStack {
                    Spacer()
                    HStack(alignment: .center){
                        Spacer()
                        Image(systemName: "magnifyingglass")
                        Text("Nothing Here")
                        Spacer()
                    }
                    Spacer()
                }
                
            }
        }
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(cart: CartViewModel(cart: Cart(items: [], note: "")), subCategory: .constant(SubCat(name: "itlog", color: .yellow, category: "Breakfast")), selectedItem: CatItem(subcategory: "itlog", name: "omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99))
    }
}
