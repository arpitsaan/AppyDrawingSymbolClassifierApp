//
//  ContentView.swift
//  drawings
//
//  Created by Arpit Agarwal on 11/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//

import SwiftUI
import PencilKit
import Combine

struct ContentView : View {
    
    @State var isShowingTraining = true
    
    var body: some View {
        
        VStack {
            Toggle.init(isOn: $isShowingTraining) {
                Text("Show Training [TURN OFF DARK MODE!]")
            }.border(Color.white.opacity(0.1))
            
            
            if (self.isShowingTraining) {
                TrainingGridView().environmentObject(CanvasGridStore())
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
    
    private let classifier = MLSymbolDetector()
    
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
                self.canvas.frame(width: 112, height: 112, alignment: .center).border(Color.yellow, width: 1)
                
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
            
            //Model Description
            ScrollView {
                Text(classifier.modelDescription)
            }
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

final class CanvasGridStore: ObservableObject {
    let didChange = PassthroughSubject<CanvasGridStore, Never>()

    @Published var canvasGrid = PencilCanvasGrid(6, 6)

    func resetGrid() {
        for row in self.canvasGrid.canvases {
            for cell in row {
                cell.canvasView.drawing = PKDrawing()
            }
        }
        self.didChange.send(self)
    }
    
}


struct TrainingGridView : View {
    var activityViewController = SwiftUIActivityViewController()
    @State var nameText = ""
    @State var imagesToSave = [UIImage]()
    @State private var selectedCategory = 0
    @State private var showingAlert = false
    @EnvironmentObject private var gridStore:CanvasGridStore

    
    var categories = ["tick", "cross", "circle"]
    
    var body: some View {
        VStack {
            
            //Save Button
            Button(action: {
                self.imagesToSave = self.gridStore.canvasGrid.getAllImages(skipEmpty: true)
                let categoryName = self.categories[self.selectedCategory]
                self.saveImages(self.imagesToSave, for: categoryName)
                self.showingAlert = true
            }) {
                ShareButtonView(activityViewController: activityViewController)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Saved \(self.imagesToSave.count) images for \(self.categories[selectedCategory])."), message: nil, dismissButton: .default(Text("OK")){
                    self.gridStore.resetGrid()
                    })
            }
            
            
            //Grid
            self.gridStore.canvasGrid
            
            //Category Picker
            Picker(selection: $selectedCategory, label: Text("Category")) {
                ForEach(0 ..< categories.count) {
                    Text(self.categories[$0])
                }
            }
        }
    }
    
    func saveImages(_ images: [UIImage], for categoryName: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMd'_'HH:mm:ss"
        let timeString = dateFormatter.string(from: Date())
        
        DispatchQueue.global(qos: .background).async {
            for i in 0..<images.count {
                let image = images[i]
                let op = self.saveImage(image, category: categoryName.lowercased(), fileIndex: i, timeString: timeString)
                DispatchQueue.main.async {
                    print(op)
                }
            }
        }
    }
    
    
    func saveImage(_ chosenImage: UIImage, category: String, fileIndex: Int, timeString: String) -> String {
        
        
        let directoryPath =  NSHomeDirectory().appending("/Documents/\(category)/\(category)-\(timeString)/")
        
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let filename = "\(category)_\(fileIndex)_\(timeString).png"
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try chosenImage.pngData()?.write(to: url, options: .atomic)
            return String.init("\(directoryPath)/\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

