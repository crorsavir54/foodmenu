//
//  OrdersView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/27/21.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var orderViewModel: Orders
    
    var body: some View {
        List {
            Section(header: HStack { Text("Pending")
                Text("\(orderViewModel.pendingCount())")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(.orange))
            }) {
                VStack {
                    OrderInfo(orderViewModel: orderViewModel, status: .pending)
                }
                
            }
            Section(header: Text("Completed")) {
                OrderInfo(orderViewModel: orderViewModel, status: .fullfilled)
            }
            Section(header: Text("Cancelled")) {
                OrderInfo(orderViewModel: orderViewModel, status: .cancelled)
            }
        }.listStyle(.sidebar)
    }
}

struct OrderInfo: View {
    @ObservedObject var orderViewModel: Orders
    var status: OrderStatus
    
    var body: some View {
        VStack(alignment:.leading) {
            ForEach(orderViewModel.orders.filter{$0.status == status}) { order in
                Text("order id: \(order.id ?? "")")
                    .fontWeight(.bold)
                ForEach(order.order.items.removingDuplicates(), id:\.self) { items in
                    Text("\(items.name) x \(orderViewModel.itemNumber(order: order, item: items), specifier: "%.0f")")
                }
                if status == .pending {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .fullfilled)
                            }
                            
                        }, label: {
                            Text("Fulfill")
                        }).buttonStyle(GrowingButton())
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .cancelled)
                            }
                            
                        }, label: {
                            Text("Cancel")
                        }).buttonStyle(GrowingButton())
                        Spacer()
                    }
                }
                if status == .fullfilled {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .pending)
                            }
                        }, label: {
                            Text("Move to pending")
                        }).buttonStyle(GrowingButton())
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .cancelled)
                            }
                            
                        }, label: {
                            Text("Cancel")
                        }).buttonStyle(GrowingButton())
                        Spacer()
                    }
                }
                if status == .cancelled {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .pending)
                            }
                        }, label: {
                            Text("Move to pending")
                        }).buttonStyle(GrowingButton())
                        Button(action: {
                            withAnimation {
                                orderViewModel.changeOrderStatus(order: order, status: .fullfilled)
                            }
                        }, label: {
                            Text("completed")
                        }).buttonStyle(GrowingButton())
                        Spacer()
                    }
                }
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(orderViewModel: Orders())
    }
}
