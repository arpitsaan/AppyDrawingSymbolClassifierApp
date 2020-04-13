//
//  ContentView.swift
//  drawings
//
//  Created by Arpit Agarwal on 11/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//

import SwiftUI
import PencilKit

struct ContentView : View {
    
    
    var body: some View {
        
        DetectionView()
        
        //TrainingGridView()
    }
}

struct DetectionView : View {
    @State var canvas = PencilCanvas()
    @State var text = " "
    
    private let classifier = TickCrossDetector()
    
    var body: some View {
        VStack {
                
                //Clear button
                Button(action: {
                    self.clearCanvas()
                }) {
                    ClearButtonView()
                }
                
                
                //Magic Button
                Button(action: {
                    self.updateClassification()
                }) {
                    MagicButtonView()
                }
                

            HStack {
            self.canvas.frame(width: 100, height: 100, alignment: .center).border(Color.yellow, width: 1)
                Text(self.text).font(.headline)
                
            }.border(Color.gray)
        }
    }
    
}

//helpers
extension DetectionView {
    private func clearCanvas() {
        self.canvas.canvasView.drawing = PKDrawing()
        self.text = "  "
    }
    
    private func updateClassification() {
        let sizeRect = self.canvas.canvasView.bounds
        let image = self.canvas.canvasView.drawing.image(from: sizeRect, scale: 4)
        self.classifier.updateClassifications(for: image) { (result) in
            switch result {
            case .failure(_):
                self.text = "E"
            case .success(let symbol):
                self.text = symbol.rawValue
            }
        }
    }
}


struct TrainingGridView : View {
    var activityViewController = SwiftUIActivityViewController()
    @State var canvasGrid = PencilCanvasGrid()
    
    var body: some View {
        VStack {
            HStack {
                
                //Share Button
                Button(action: {
                    let images = self.canvasGrid.getAllImages()
                    self.activityViewController.shareImages(images)
                }) {
                    ShareButtonView(activityViewController: activityViewController)
                }
            }
            
            self.canvasGrid //show canva
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

