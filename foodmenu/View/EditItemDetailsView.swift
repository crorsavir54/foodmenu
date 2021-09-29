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
    @State private var selectedSubCategory = ""
    @State private var selectedStockStatus = true
    @State private var image = UIImage()
    @State private var imageBefore = UIImage()
    @State private var imageSet = false
    @State private var showSheet = false
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
                            AnimatedImage(url: URL(string: item.imageUrl))
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
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
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
            
            HStack {
                Spacer()
                Button(action: {
                    upload(image: image)
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
