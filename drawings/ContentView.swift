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
    
    @State var isShowingTraining = false
    
    var body: some View {
        
        VStack {
            Toggle.init(isOn: $isShowingTraining) {
                Text("Show Training")
            }.border(Color.white.opacity(0.1))
            
            
            if (self.isShowingTraining) {
                TrainingGridView()
            } else {
                DetectionView()
            }
            
        }
        
        
        //TrainingGridView()
    }
}

struct DetectionView : View {
    @State var canvas = PencilCanvas()
    @State var text = " "
    @State var descriptionText = " "
    
    private let classifier = TickCrossDetector()
    
    var body: some View {
        VStack {
            //Clear button
            Button(action: {
                self.clearCanvas()
            }) {
                ClearButtonView()
            }
            
            //Detection area
            HStack {
            self.canvas.frame(width: 100, height: 100, alignment: .center).border(Color.yellow, width: 1)
                
                Text(self.text).font(.headline).padding().frame(width: 500, height: 100, alignment: .leading)
                
            }.border(Color.gray)
            
            
            //Magic Button
            Button(action: {
                self.updateClassification()
            }) {
                MagicButtonView()
            }
            
            //Description
            Text(self.descriptionText).lineLimit(10).frame(width: 500, height: 100, alignment: .center)
        }
    }
    
}

//helpers
extension DetectionView {
    private func clearCanvas() {
        self.canvas.canvasView.drawing = PKDrawing()
        self.text = "  "
        self.descriptionText = "  "
    }
    
    private func updateClassification() {
        let sizeRect = self.canvas.canvasView.bounds
        let image = self.canvas.canvasView.drawing.image(from: sizeRect, scale: 4)
        self.classifier.updateClassifications(for: image) { (result) in
            switch result {
            case .failure(_):
                self.text = "E"
                self.descriptionText = "  "
                
            case .success(let symbol):
                self.text = symbol.rawValue
                self.descriptionText = self.classifier.text
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

