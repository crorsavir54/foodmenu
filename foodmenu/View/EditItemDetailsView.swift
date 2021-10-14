//
//  EditItemDetailsView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/26/21.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

struct EditItemDetailsView: View {
    @ObservedObject var mainMenu: OrderMenu
    @Binding var item: CatItem
    var didAddItem: (_ item: CatItem) -> Void
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedSubCategory = ""
    @State private var selectedStockStatus = true
    @State private var image = UIImage()
    @State private var imageBefore = UIImage()
    @State private var imageSet = false
    @State private var showSheet = false
    @State private var showPhotos = false
    @State private var buttonTappable = false
    @State private var presentCamera = false
    //    @State private var selectedCategory = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                Section(header: Text("Set Image")) {
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
                                AnimatedImage(url: URL(string: item.imageUrl))
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
                }
                    Section(header: Text("Stock Status")) {
                        Toggle("In Stock?", isOn: $item.inStock)
                    }
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
                    Section(header: Text("Category")) {
                        Picker("SubCategory", selection: $selectedSubCategory) {
                            ForEach(mainMenu.allSubCategories(), id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.inline)
                        //                            .labelsHidden()
                    }
                }
                .sheet(isPresented: $showPhotos, onDismiss: compareImages) {
                    ImagePicker(sourceType: presentCamera ? .camera : .photoLibrary, selectedImage: self.$image)
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        let newItem = item
                        didAddItem(newItem)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        item.subcategory = selectedSubCategory
                        let newItem = item
                        upload(image: image)
                        didAddItem(newItem)
                        
                    }
                    
                }
            }
        }
        .onAppear {
            selectedSubCategory = item.subcategory
            
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
                item.imageUrl = downloadURL.absoluteString
                item.subcategory = selectedSubCategory
                let newItem = item
                didAddItem(newItem)
            }
        }
    }
}


//struct EditItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditItemDetailsView(mainMenu: OrderMenu(), item: .constant(CatItem(subcategory: "itlog", name: "omelette", description: "Itlog na gi batil, tas gi prito?", price: 9.99)))
//    }
//}
