//
//  EditItemDetailsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/26/21.
//

import SwiftUI

struct EditItemDetailsView: View {
    @ObservedObject var mainMenu: OrderMenu
    @Binding var item: CatItem
    var didAddItem: (_ item: CatItem) -> Void
    @State private var selectedSubCategory = ""
    @State private var selectedStockStatus = true
    //    @State private var selectedCategory = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Name", text: $item.name)
                }
                Section(header: Text("Item Price")) {
                    TextField("Price", value: $item.price, formatter: formatter)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Item Description")) {
                    TextField("description", text: $item.description)
                }
            }
            Toggle("In Stock?", isOn: $item.inStock)
            List {
                Section {
                    Picker("SubCategory", selection: $selectedSubCategory) {
                        ForEach(mainMenu.allSubCategories(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.inline)
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    item.subcategory = selectedSubCategory
                    let newItem = item
                    didAddItem(newItem)
                }, label: {
                    Text("Confirm")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.size.width/3, height: 55, alignment: .center)
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
        }.onAppear {
            selectedSubCategory = item.subcategory

        }

    }
}

//struct EditItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItemDetailsView(mainMenu: OrderMenu(), item: .constant(CatItem(subcategory: "itlog", name: "omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99)))
//    }
//}
