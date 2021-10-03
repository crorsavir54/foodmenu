//
//  SubCategoryCardView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/17/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SubCategoryCardView: View {
    
    
    var subCategoryName = "Main"
    var cardColor: Color = .orange
    var image: String = ""
    //    var image: Image
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: geometry.size.height - (geometry.size.height + 15)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(.orange.opacity(0.1))
                    if image != "" {
                        AnimatedImage(url: URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        
                    } else {
                        Image("cloche")
//                            .padding(30)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width-30, height: geometry.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }

                }

                    
                VStack(alignment: .center) {
                    HStack {
                        Text(subCategoryName)
                            .font(.system(size: geometry.size.width/12))
//                            .fontWeight(.semibold)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.orange))
                            .foregroundColor(.white)
                            .clipped()
                            .shadow(radius: 2)
//                            .padding()
                    }
                    Spacer()
                }
            }
        }
        
    }
}

struct SubCategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        SubCategoryCardView(cardColor: .green)
    }
}
