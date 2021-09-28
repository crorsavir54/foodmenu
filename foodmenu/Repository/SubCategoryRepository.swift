//
//  SubCategoryRepository.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import Foundation

import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

final class SubCategoryRepository: ObservableObject {
    private let store = Firestore.firestore()
    private let path = "subcategories"

    @Published var subCategories = [SubCat]()

    init() {
        get()
    }
    func get() {
        let userId = Auth.auth().currentUser?.uid
        store.collection(path)
            .whereField("userId", isEqualTo: userId!)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.subCategories = snapshot?.documents.compactMap {
                try? $0.data(as: SubCat.self)
            } ?? []
        }
    }

    func add(_ subCategory: SubCat) {
        do {
            var addedSubCategory = subCategory
            addedSubCategory.userId = Auth.auth().currentUser?.uid
            _ = try store.collection(path).addDocument(from: addedSubCategory)
        } catch {
            fatalError("Adding subcategory failed")
        }
    }

    func remove(_ subCategory: SubCat) {
        guard let documentId = subCategory.id else { return }
        store.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove subcategory : \(error.localizedDescription)")
            }

        }
    }

    func update(_ subCategory: SubCat) {
        guard let documentId = subCategory.id else { return }
        do {
            _ = try store.collection(path).document(documentId).setData(from: subCategory)
        } catch {
            fatalError("Updating subcategory failed")
        }
    }



}
