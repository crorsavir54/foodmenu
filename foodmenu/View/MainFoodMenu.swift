//
//  ContentView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/16/21.
//

import SwiftUI

struct mainFoodMenu: View {
    @State var selected = "Main"
    var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("My Restaurant")
                        .font(.system(size: geometry.size.height/30))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Spacer()
                    Button(action: {}, label: {
                        HStack{
                            Image(systemName: "cart")
                                .font(.largeTitle)
                            Text("1")
                                .font(.title)
                        }
                        .padding()
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .foregroundColor(.white)
                    })
                }
                // Top bar
                .padding(.bottom)
                .padding(.leading)
                .padding(.trailing)
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(20))], alignment: .center, spacing: 20, content: {
                        ForEach(Categories.categories, id:\.self) { category in
                            VStack {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .fill(Color.gray)
                                        .brightness(selected == category.name ? 0 : 0.4)
                                        .frame(width: 120, height: 120)
                                    Text(category.icon)
                                        .font(.system(size:50))
                                }
                                Text(category.name)
                            }
                        }
                    })
                    .frame(minWidth: geometry.size.width, maxHeight: 150 ,alignment: .leading)
                    .padding(.leading)
                } // Category Scroll View
                subCategory
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Order")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width , height: 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.orange)
                })
                
            }
            .edgesIgnoringSafeArea([.bottom])
            .padding(.top)
        }
    }
    
    var subCategoryColumns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [ GridItem(.flexible(minimum: 40), spacing: 10),
                     GridItem(.flexible(minimum: 40), spacing: 10),
                     GridItem(.flexible(minimum: 40), spacing: 10),
           ]
        } else {
            return [ GridItem(.flexible(minimum: 40), spacing: 10),
                     GridItem(.flexible(minimum: 40), spacing: 10),
           ]
        }
    }
    
    var subCategory: some View {
        GeometryReader { geometry in
            NavigationView{
                ScrollView {
                    LazyVGrid(columns: subCategoryColumns, spacing: 10, content: {
                        ForEach(Categories.subCategories, id:\.self) { subcategory in
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                SubCategoryCardView(subCategoryName: subcategory.name, cardColor: subcategory.color, image: subcategory.image)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(minHeight: 100, idealHeight: 350, maxHeight: 400)
                            } else {
                                SubCategoryCardView(subCategoryName: subcategory.name, cardColor: subcategory.color,image: subcategory.image)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(minHeight: 50, idealHeight: 250, maxHeight: 300)
                                }
                            }
                        }
                    )
                }
                .padding(.leading)
                .padding(.trailing)
                .navigationTitle("\(selected) Menu")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        mainFoodMenu()
    }
}
