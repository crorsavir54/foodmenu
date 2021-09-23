//
//  SubCategoryCardView.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 9/17/21.
//

import SwiftUI

struct SubCategoryCardView: View {
    
    var subCategoryName = "Main"
    var cardColor: Color
    var image: Image
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(cardColor.opacity(0.1))
                    .clipped()
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x:geometry.size.width/2, y:geometry.size.height/2 + 50)
                    .shadow(radius: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                VStack {
                    HStack {
                        Text(subCategoryName)
                            .font(.system(size: geometry.size.width/12))
                            .fontWeight(.semibold)
                            .padding()
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }

            }
        }

    }
}

struct SubCategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        SubCategoryCardView(cardColor: .green, image: Image("kaldereta"))
    }
}
