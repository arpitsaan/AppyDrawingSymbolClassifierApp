//
//  Archive.swift
//  drawings
//
//  Created by Arpit Agarwal on 13/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//
//
//
////Saving code for later use here
//var labeledCanvases = [[LabeledPencilCanvas]]()
//
//
//func classifyAllImages() {
//    for row in self.labeledCanvases {
//        for cell in row {
//            cell.classifyImage()
//        }
//    }
//}
//
//mutating func showClassificationText() {
//    var str = ""
//    for row in self.labeledCanvases {
//        for cell in row {
//            str += cell.text + " | "
//        }
//        str += "\n"
//    }
//    self.text = str
//}
//
//func classifyImagesThroughParentView() {
//    var temptext = ""
//    for i in 0..<self.labeledCanvases.count {
//        let row = self.labeledCanvases[i]
//        
//        for j in 0..<row.count {
//            let lc = self.labeledCanvases[i][j]
//            let size = lc.canvas.canvasView.bounds
//            let bitmap = lc.canvas.canvasView.drawing.image(from: size, scale: 4)
//            
//            let tcd = TickCrossDetector.init()
//            tcd.updateClassifications(for: bitmap) { (result) in
//                switch result {
//                case .success(let string):
//                    lc.text = string
//                    temptext = "\(temptext),\(string)"
//                    
//                case .failure(_):
//                    lc.text = "E"
//                    temptext = "\(temptext), E"
//                }
//                DispatchQueue.main.async {
//                    self.text = temptext
//                    print(self.text)
//                }
//            }
//        }
//    }
//}
