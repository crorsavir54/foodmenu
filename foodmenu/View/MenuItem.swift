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
                        Image(systemName: "chevron.backward.square")
                        Spacer()
                        Spacer()
                        Text(subCategory.name)
                            .fontWeight(.semibold)
                        Spacer()
                        HStack {
                            Image(systemName: "square.fill.text.grid.1x2")
                            Image(systemName: "square.grid.2x2")
                        }

                    }
                    .font(.largeTitle)
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
                                                    .fill(Color.gray)
                                                    .opacity(selectedItem.name == item.name ? 0.2 : 0)
                                                    
                                                    .frame(width: geometry.size.width/4.5, height: geometry.size.width/4.5)
                                                
                                                Image(item.imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .padding()
                                                    .frame(width: geometry.size.width/4, height: geometry.size.width/4, alignment: .leading)
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
                            .frame(width: geometry.size.width/4+30)
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
                                Text(selectedItem.description)

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
