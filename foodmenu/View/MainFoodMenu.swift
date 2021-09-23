//
//  ContentView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/16/21.
//

import SwiftUI

struct mainFoodMenu: View {
    
    @Namespace var namespace
    @State var selectedCategoryName = Restaurant.main.name
    @State var selectedCategory = SubCategory.mainSubCategories
    @State var selectedSubCategory = SubCategory.itlog
    @State var cart = Cart.cart1
    @State var isSubcategoryPresented = false
    @State var isCartPresented = false
    
    
    
    
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack (spacing: 0) {
                    HStack {
                        Button(action: {
                            // TODO: - Show menu
                            print("Show Menu")
                        }, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: geometry.size.height/30))
                                .foregroundColor(.orange)
                        })
                        Text("My Restaurant")
                            .font(.system(size: geometry.size.height/25))
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        Spacer()
                        Button(action: {
                            //TODO: Show cart content
                            isCartPresented.toggle()
                            print("Show Cart Content")
                        }, label: {
                            HStack{
                                Image(systemName: "cart")
                                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .title)
                                Text("\(cart.items.count)")
                                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .body)
                                    .padding(.trailing)
                            }
                            .padding(10)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundColor(.white)
                        })
                    }
                    // Top bar
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(20))], alignment: .center, spacing: 20, content: {
                            ForEach(Restaurant.categories, id:\.self) { category in
                                VStack {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.gray)
                                            .brightness(selectedCategoryName == category.name ? 0 : 0.4)
                                            .frame(width: geometry.size.width/5, height: geometry.size.width/5)
                                        Text(category.icon)
                                            .font(.system(size:geometry.size.width/10))
                                    }
                                    Text(category.name)
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .body : .caption)
                                }
                                .padding(5)
                                .onTapGesture {
                                    withAnimation(){
                                        selectedCategoryName = category.name
                                        selectedCategory = category.subcategories
                                    }
                                    
                                }
                            }
                        })
                            .frame(minWidth: geometry.size.width, maxHeight: geometry.size.width/5+20 ,alignment: .leading)
                            .padding(.leading)
                    } // Category Scroll View
                    subCategory
                }
                .edgesIgnoringSafeArea([.bottom])
                .padding(.top)
            }
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        // TODO: Toggle order summary sheet, and make order
                        isCartPresented.toggle()
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
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    
                }
            }.edgesIgnoringSafeArea([.bottom])
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
                        ForEach(selectedCategory, id:\.self) { subcategory in
                            Button(action: {
                                isSubcategoryPresented.toggle()
                                selectedSubCategory = subcategory
                            }, label: {
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    SubCategoryCardView(subCategoryName: subcategory.name, cardColor: subcategory.color, image: subcategory.image)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 100, idealHeight: 350, maxHeight: 400)
                                    
                                } else {
                                    SubCategoryCardView(subCategoryName: subcategory.name, cardColor: subcategory.color,image: subcategory.image)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 50, idealHeight: 250, maxHeight: 300)
                                }
                            }).foregroundColor(.black)
                                .buttonStyle(GrowingButton())
                        }
                    }
                    )
                }
                .padding(.leading)
                .padding(.trailing)
                .navigationTitle("\(selectedCategoryName) Menu")
                .sheet(isPresented: $isSubcategoryPresented) {
                    MenuItem(subCategory: $selectedSubCategory, selectedItem: selectedSubCategory.items.isEmpty ? Item.omelette : selectedSubCategory.items[0])
                }
                .sheet(isPresented: $isCartPresented) {
                    CartView()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        mainFoodMenu()
    }
}
