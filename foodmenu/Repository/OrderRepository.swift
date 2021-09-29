//
//  ItemRepository.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import Foundation

import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

final class OrderRepository: ObservableObject {
    private let store = Firestore.firestore()
    private let path = "orders"

    @Published var orders = [Order]()

    init() {
        get()
    }
    func get() {
        let userId = Auth.auth().currentUser?.uid
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.orders = snapshot?.documents.compactMap {
                try? $0.data(as: Order.self)
            } ?? []
        }
    }

    func add(_ order: Order) {
        do {
            var addedOrder = order
            addedOrder.userId = Auth.auth().currentUser?.uid
            _ = try store.collection(path).addDocument(from: addedOrder)
        } catch {
            fatalError("Adding order failed")
        }
    }

    func remove(_ order: Order) {
        guard let documentId = order.id else { return }
        store.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove order : \(error.localizedDescription)")
            }

        }
    }
    
    func update(_ order: Order) {
        guard let documentId = order.id else { return }
        do {
            _ = try store.collection(path).document(documentId).setData(from: order)
        } catch {
            fatalError("Updating item failed")
        }
    }
    
    func updateStatus(_ order: Order, status: OrderStatus) {
        guard let documentId = order.id else { return }
        store.collection(path).document(documentId).updateData(["status": status]) { error in
            if let error = error {
                print("error updateing document: \(error.localizedDescription)")
            } else {
                print("successfully updated")
            }
        }
    }



}
