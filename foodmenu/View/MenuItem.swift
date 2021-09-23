//
//  MenuItem.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/21/21.
//

import SwiftUI

struct MenuItem: View {
    @Binding var subCategory: SubCategory
    @State var selectedItem: Item
    @State var tabNames = ["All", "New", "Popular", "New Items"]
    
    let columns = [
        GridItem(.flexible(minimum: 40), spacing: 10)
    ]
    
    var body: some View {
        
        GeometryReader { geometry in
            if !subCategory.items.isEmpty {
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
                                    ForEach(subCategory.items, id:\.self) { item in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                                    .stroke(lineWidth: 0.1)
                                                    .opacity(selectedItem.name == item.name ? 0 : 0.5)
                                                    .frame(width: geometry.size.width/4.5, height: geometry.size.width/4.5)
                                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                                    .fill(Color.gray)
                                                    .opacity(selectedItem.name == item.name ? 0.2 : 0)
                                                    .frame(width: geometry.size.width/4.5, height: geometry.size.width/4.5)
                                                
                                                Image(item.imageName)
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
                                Image(selectedItem.imageName)
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
                                HStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {}) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.orange)
                                                .font(.title)
                                        }
                                        Text("1")
                                            .padding(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.orange, lineWidth: 2))
                                        Button(action: {}) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.orange)
                                                .font(.title)
                                        }
                                        Spacer()
                                    }
                                    
                                }.padding(.bottom)
                                HStack {
                                    Spacer()
                                    Button(action: {}) {
                                        Text("Add to Order")
                                            .fontWeight(.bold)
                                            .padding()
//                                            .overlay(RoundedRectangle(cornerRadius: 30)
//                                                        .foregroundColor(.orange))
                                            .background(RoundedRectangle(cornerRadius: 30)
//                                                            .strokeBorder()
                                                            .frame(width: 150, height: 40)
                                                            .foregroundColor(.orange))
//                                            .foregroundColor(.orange)
                                    }.foregroundColor(.white)
                                    Spacer()
                                }
                            }
                            .frame(width: geometry.size.width/2, alignment: .leading)
                        Spacer()
                        }
                    
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
        MenuItem(subCategory: .constant(SubCategory.itlog), selectedItem: Item.omelette)
    }
}
