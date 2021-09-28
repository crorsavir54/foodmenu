//
//  CategoryRepository.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/28/21.
//

import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore

final class CategoryRepository: ObservableObject {
    private let store = Firestore.firestore()
    private let path = "categories"
    
    @Published var mainCategories = [MainCategory]()
    
    init() {
        get()
    }
    func get() {
        store.collection(path).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.mainCategories = snapshot?.documents.compactMap {
                try? $0.data(as: MainCategory.self)
            } ?? []
        }
    }
    
    func add(_ category: MainCategory) {
        do {
            _ = try store.collection(path).addDocument(from: category)
        } catch {
            fatalError("Adding category failed")
        }
    }
    
    func remove(_ category: MainCategory) {
        guard let documentId = category.id else { return }
        store.collection(path).document(documentId).delete { error in
            if let error = error {
                print("Unable to remove card : \(error.localizedDescription)")
            }
            
        }
    }
    
    func update(_ category: MainCategory) {
        guard let documentId = category.id else { return }
        do {
            _ = try store.collection(path).document(documentId).setData(from: category)
        } catch {
            fatalError("Updating category failed")
        }
    }
    
    
    
}
