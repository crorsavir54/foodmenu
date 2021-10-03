//
//  ButtonStyles.swift
//  foodmenu
//
//  Created by coriv🧑🏻‍💻 on 10/3/21.
//

import Foundation
import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

struct ConfirmButton: ButtonStyle {
    var cornerRadius: CGFloat = 20
    var color = Color.orange
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)

            .background(color)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .foregroundColor(configuration.isPressed ? .orange : .white)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}
