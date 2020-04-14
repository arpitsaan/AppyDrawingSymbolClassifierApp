//
//  TickCrossDetector.swift
//  drawings
//
//  Created by Arpit Agarwal on 12/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//
import SwiftUI
import CoreML
import Vision
import ImageIO

class MLSymbolDetector {
    // MARK: - Image Classification
    
    typealias Handler<T> = (Result<T, Error>) -> Void
    
    var symbolType = SymbolType.unknown
    var text = ""
    var modelDescription = " "
    private var compHandler:Handler<SymbolType>?
    private var err = NSError.init(domain: "Random Arpit Error", code: 420, userInfo: nil)
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let rawModel = ArpitDrawingClassifier().model
            self.modelDescription = "\(ArpitDrawingClassifier.urlOfModelInThisBundle.absoluteString)\n\n\(rawModel.modelDescription.metadata.debugDescription) \n\n \(rawModel.configuration.debugDescription) \n\n \(rawModel.modelDescription.outputDescriptionsByName) \n\n \(rawModel.modelDescription.predictedFeatureName ?? "")\n\n \(rawModel.modelDescription.predictedProbabilitiesName ?? "")"
            
            print("[Arpit DEBUG] Model Desciption\n", rawModel.modelDescription.metadata.description)
            
            let model = try VNCoreMLModel(for: rawModel)
            
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage, completion: @escaping Handler<SymbolType>) {
        self.compHandler = completion
        
        self.text = ""
        self.symbolType = .unknown
        
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [VNImageOption : Any]())
            do {
                let req = self.classificationRequest
                try handler.perform([req])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
            
            
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.text = "Unable to classify image.\n\(error!.localizedDescription)"
                if let h = self.compHandler {
                    h(.failure(NSError.init(domain: self.text, code: 1, userInfo: nil)))
                }
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.text = "Nothing recognized."
                if let h = self.compHandler {
                    h(.failure(NSError.init(domain: self.symbolType.rawValue, code: 2, userInfo: nil)))
                }
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.text = "Classification:\n" + descriptions.joined(separator: "\n")
                print(self.text)
                
                if let h = self.compHandler, let label = topClassifications.first?.identifier {
                    
                    if let symbol = SymbolType.init(rawValue: label) {
                        h(.success(symbol))
                    } else {
                        h(.success(.unknown))
                    }
                }
            }
        }
    }
}
