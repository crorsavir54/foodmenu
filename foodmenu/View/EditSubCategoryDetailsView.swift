//
//  EditSubCategoryDetailsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/26/21.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct EditSubCategoryDetailsView: View {
    @ObservedObject var mainMenu: OrderMenu
    @Binding var subCategory: SubCat
    var didAddSubCategory: (_ item: SubCat) -> Void
    @State private var selectedCategory = ""
    @State private var image = UIImage()
    @State private var imageBefore = UIImage()
    @State private var imageSet = false
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Item Name")) {
                    TextField("Name", text: $subCategory.name)
                }
                Section() {
                    Picker("Categories", selection: $selectedCategory) {
                        ForEach(mainMenu.allCategories(), id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.inline)
                }
                Section() {
                    HStack {
                        if imageSet {
                            Image(uiImage: self.image)
                                .resizable()
                                .cornerRadius(50)
                                .frame(width: 100, height: 100)
                                .background(Color.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        } else {
                            AnimatedImage(url: URL(string: subCategory.imageUrl))
                                .resizable()
                                .cornerRadius(50)
                                .frame(width: 100, height: 100)
                                .background(Color.black.opacity(0.2))
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        }

                        Text("Change photo")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.orange)
                            .cornerRadius(16)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                showSheet = true
                                imageBefore = image
                            }
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $showSheet, onDismiss: compareImages) {
                        // Pick an image from the photo library:
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                        //  If you wish to take a photo from camera instead:
                        // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    }
                }
            }
            .navigationTitle("Edit Subcategory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        let newSubCategory = subCategory
                        didAddSubCategory(newSubCategory)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        subCategory.category = selectedCategory
                        let newSubCategory = subCategory
                        didAddSubCategory(newSubCategory)
                        upload(image: image)
                    }
                    
                }
            }
        }
        .onAppear {
            selectedCategory = subCategory.category
        }
    }
    func compareImages() {
        if !imageBefore.isEqual(image) {
            imageSet = true
            
        }
    }
    
    func upload(image: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images/\(image).jpg")
        let data = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the file to the path "images/"
        let uploadTask = storageRef.putData(data!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                subCategory.imageUrl = downloadURL.absoluteString
                subCategory.category = selectedCategory
                let newSubCategory = subCategory
                didAddSubCategory(newSubCategory)
            }
        }
    }
}

//struct EditSubCategoryDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSubCategoryDetailsView()
//    }
//}
