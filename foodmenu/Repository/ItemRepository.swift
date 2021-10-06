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

final class ItemRepository: ObservableObject {
    private let store = Firestore.firestore()
    private let path = "items"

    @Published var items = [CatItem]()

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
            self.items = snapshot?.documents.compactMap {
                try? $0.data(as: CatItem.self)
            } ?? []
        }
    }
    
    func updateSubcategoryName(newName: String, subcategory: String) {
        let userId = Auth.auth().currentUser?.uid
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
            .whereField("subcategory", isEqualTo: subcategory)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            let itemsToUpdate = snapshot?.documents.compactMap {
                try? $0.data(as: CatItem.self)
            } ?? []
                for item in itemsToUpdate {
                    var newCat = item
                    newCat.subcategory = newName
                    self.update(newCat)
                }
                print(itemsToUpdate.count)
        }
    }

    func add(_ item: CatItem) {
        do {
            var addedItem = item
            addedItem.userId = Auth.auth().currentUser?.uid
            _ = try store.collection(path).addDocument(from: addedItem)
        } catch {
            fatalError("Adding item failed")
        }
    }

    func remove(_ item: CatItem) {
        guard let documentId = item.id else { return }
        store.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove item : \(error.localizedDescription)")
            }

        }
    }

    func update(_ item: CatItem) {
        guard let documentId = item.id else { return }
        do {
            _ = try store.collection(path).document(documentId).setData(from: item)
        } catch {
            fatalError("Updating item failed")
        }
    }



}
