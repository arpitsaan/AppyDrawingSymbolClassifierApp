//
//  Buttons.swift
//  drawings
//
//  Created by Arpit Agarwal on 13/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//

import Foundation
import SwiftUI

struct MagicButtonView: View {
    
    var body: some View {
        HStack {
            Image(systemName: "wand.and.rays")
                .font(.title)
            Text("Magic")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5)
        .padding(.horizontal, 20)
        .disabled(false)
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .trailing)
    }
}

struct ClearButtonView: View {
        
    var body: some View {
        HStack {
            Image(systemName: "xmark")
                .font(.title)
            Text("Clear")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5)
        .padding(.horizontal, 20)
        .disabled(false)
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
    }
}


struct ShareButtonView: View {
    
    let activityViewController: SwiftUIActivityViewController
    
    var body: some View {
        HStack {
            Image(systemName: "square.and.arrow.up")
                .font(.title)
            Text("Share All (60)")
                .fontWeight(.semibold)
                .font(.title)
            activityViewController
        }
        .padding()
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5)
        .padding(.horizontal, 20)
        .disabled(false)
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
    }
}
