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
    @State private var showPhotos = false
    @State private var presentCamera = false
    
    
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
                        Spacer()
                        VStack {
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
                                    .scaledToFill()
                                    .cornerRadius(50)
                                    .frame(width: 100, height: 100)
                                    .background(Color.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                        }
                        Image(systemName: "camera.viewfinder")
                            .font(.largeTitle)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.orange, .black.opacity(0.8))
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                showSheet = true
                                imageBefore = image
                                presentCamera = true
                                showPhotos.toggle()
                            }
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.orange, .black.opacity(0.8))
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                showSheet = true
                                imageBefore = image
                                presentCamera = false
                                showPhotos.toggle()
                            }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $showPhotos, onDismiss: compareImages) {
                        ImagePicker(sourceType: presentCamera ? .camera : .photoLibrary, selectedImage: self.$image)
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
        var data = Data()
        if let newImage = image.pngData() {
            data = newImage
        } else {
            if let jpeg = image.jpegData(compressionQuality: 0.2) {
                data = jpeg
            } else {
                return
            }
           
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Upload the file to the path "images/"
        _ = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
//            _ = metadata.size
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
