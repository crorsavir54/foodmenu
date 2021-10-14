//
//  ContentView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/16/21.
//

import SwiftUI

struct mainFoodMenu: View {
    
    @Namespace var namespace
    @ObservedObject var mainCategories = OrderMenu()
    @ObservedObject var cart = CartViewModel(cart: Cart(items: [], note: ""))
    @ObservedObject var orderViewModel = Orders()
    @State var selectedCategory = MainCategory(name: "Main", icon: "🍽")
    @State var subcategories: [SubCat] = [SubCat(name: "", category: "")]
    @State var selectedSubCategory = SubCat(name: "", category: "")
    @State var isSubcategoryPresented = false
    @State var isCartPresented = false
    @State var isEditModePresented = false
    
    // Set navigation bar title color
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
    }
    
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack (spacing: 0) {
                    HStack {
                        Button(action: {
                            print("Show Menu")
                            isEditModePresented.toggle()
                        }, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: geometry.size.height/30, weight: .bold))
                                .foregroundColor(.orange)
                        })
                        Text("My Restaurant")
                            .font(.system(size: geometry.size.height/25))
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        Spacer()
                        Button(action: {
                            isCartPresented.toggle()
                            print("Show Cart Content")
                        }, label: {
                            HStack{
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .overlay(Text("\(cart.cart.items.count)")
                                                .font(UIDevice.current.userInterfaceIdiom == .pad ? .body : .caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white))
                                    .offset(x: 22, y: -10)
                                Image("cloche")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                //                                    .opacity(0.8)
                                //                                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .title
                                
                                //                                    .padding(.trailing)
                            }
                            //                            .padding(10)
                            //                            .background(Color.orange)
                            //                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(.orange)
                        }).buttonStyle(GrowingButton())
                    }
                    // Top bar
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(20))], alignment: .center, spacing: 20, content: {
                            ForEach(mainCategories.categories, id:\.self) { category in
                                VStack {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(Color.gray)
                                            .brightness(selectedCategory.name == category.name ? 0 : 0.4)
                                            .frame(width: geometry.size.width/5, height: geometry.size.width/5)
                                        Text(category.icon)
                                            .font(.system(size:geometry.size.width/10))
                                    }
                                    Text(category.name)
                                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .body : .caption)
                                }
                                .padding(5)
                                .onAppear {
                                    selectedCategory = mainCategories.categories.first ?? MainCategory(name: "")
                                    print("ON APPEAR \(selectedCategory)")
                                }// Category Scroll View
                                .onTapGesture {
                                    withAnimation(.easeInOut){
                                        selectedCategory = category
                                        subcategories = mainCategories.allSubCategeries(category: category)
                                    }
                                }
                            }
                        })
                            .frame(minWidth: geometry.size.width, maxHeight: geometry.size.width/5+20 ,alignment: .leading)
                            .padding(.leading)
                    }
                    .navigationBarHidden(true)
                    subCategory
                }
                .edgesIgnoringSafeArea([.bottom])
                .padding(.top)
            }
            VStack {
                Spacer()
                HStack {
                    HStack(spacing: 0) {
                        Button(action: { isCartPresented.toggle() }) {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.size.width/2-30, height: 50)
                                Rectangle()
                                    .foregroundColor(.orange).opacity(0.2)
                                    .frame(width: UIScreen.main.bounds.size.width/2-30, height: 50)
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
                                    Text("*Extra charges may apply")
                                        .fontWeight(.light)
                                        .font(.system(size: 10))
                                    
                                }.padding(.leading,30)
                            }
                        }.foregroundColor(.orange)
                        Button(action: {
                            orderViewModel.addOrder(order: Order(order: cart.cart, status: .pending))
                            cart.clearCart()
                        }) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.orange)
                                    .frame(width: UIScreen.main.bounds.size.width/2-40, height: 50)
                                HStack {
                                    if cart.cart.items.isEmpty {
                                        Text("Cart empty")
                                            .fontWeight(.semibold)
                                    } else {
                                        Text("Order now")
                                            .fontWeight(.semibold)
                                        Image(systemName: "arrow.right")
                                    }
                                }
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.black.opacity(0.2),
                            radius: 3,
                            x: 1,
                            y: 3)
                    
                }.padding(.bottom)
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
                    LazyVGrid(columns: subCategoryColumns, spacing: 20, content: {
                        ForEach(mainCategories.subCategories.filter{$0.category == selectedCategory.name}, id:\.self) { subcategory in
                            Button(action: {
                                selectedSubCategory = subcategory
                                isSubcategoryPresented.toggle()
                                
                            }, label: {
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    SubCategoryCardView(subCategoryName: subcategory.name, image: subcategory.imageUrl)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 100, idealHeight: 350, maxHeight: 400)
                                } else {
                                    SubCategoryCardView(subCategoryName: subcategory.name, image: subcategory.imageUrl)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(minHeight: 50, idealHeight: 250, maxHeight: 300)
                                }
                            }).foregroundColor(.black)
                                .buttonStyle(GrowingButton())
                        }
                    }
                    )
                    //Since there is a floating button, extra space is needed for the scrollview
                    //Extra space is equal to the size of floating button
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: UIScreen.main.bounds.size.width/2-40, height: 50)
                        .foregroundColor(Color.clear)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                .navigationTitle("\(selectedCategory.name) Menu")
                .fullScreenCover(isPresented: $isSubcategoryPresented) {
                    MenuItem(items: mainCategories, cart: cart, orderViewModel: orderViewModel, subCategory: $selectedSubCategory)
                }
                .sheet(isPresented: $isCartPresented) {
                    CartView(cartView: cart, orderViewModel: orderViewModel)
                }
                .fullScreenCover(isPresented: $isEditModePresented) {
                    EditMenuView(mainCategories: mainCategories, orderViewModel: orderViewModel)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        mainFoodMenu(mainCategories: OrderMenu())
//    }
//}
