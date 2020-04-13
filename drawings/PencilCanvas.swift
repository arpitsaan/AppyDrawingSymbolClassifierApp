//
//  PencilCanvasView.swift
//  drawings
//
//  Created by Arpit Agarwal on 13/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//

import SwiftUI
import PencilKit

//Pencil Canvas
struct PencilCanvas: UIViewRepresentable {
    typealias UIViewType = PKCanvasView
    
    var canvasView = PKCanvasView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 6)
        self.canvasView.allowsFingerDrawing = false
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
    
}

//Pencil Canvas Grid
struct PencilCanvasGrid: View {
    
    var canvases = [[PencilCanvas]]()
    var rows: Int
    var cols: Int
    
    init(_ rows: Int = 6, _ cols: Int = 10) {
        self.rows = rows
        self.cols = cols
        self.setupCanvas()
    }
    
    private mutating func setupCanvas() {
        for _ in 0..<self.rows {
            var row = [PencilCanvas]()
            var textRow = [String]()
            
            for _ in 0..<cols {
                let canvas = PencilCanvas()
                row.append(canvas)
                textRow.append("-")
            }

            self.canvases.append(row)
        }
    }
    
    func getAllImages() -> [UIImage] {
        var images = [UIImage]()
        for row in self.canvases {
            for cell in row {
                let size = cell.canvasView.bounds
                let bitmap = cell.canvasView.drawing.image(from: size, scale: 4)
                images.append(bitmap)
            }
        }
        return images
    }
    
    var body: some View {
        VStack {
            GridStack(rows: self.rows, columns: self.cols) { row,col in
                self.canvases[row][col].frame(width: 100, height: 100, alignment: .center).border(Color.purple, width: 1)
            }
        }
    }
}


//Grid Helper View
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
