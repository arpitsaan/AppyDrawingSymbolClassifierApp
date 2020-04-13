//
//  AcitivityViewController.swift
//  drawings
//
//  Created by Arpit Agarwal on 12/04/20.
//  Copyright © 2020 arpitsaan. All rights reserved.
//

import UIKit
import SwiftUI

struct SwiftUIActivityViewController : UIViewControllerRepresentable {
    
    let activityViewController = ActivityViewController()
    
    func makeUIViewController(context: Context) -> ActivityViewController {
        activityViewController
    }
    func updateUIViewController(_ uiViewController: ActivityViewController, context: Context) {
    }
    
    func shareImage(uiImage: UIImage) {
        activityViewController.imageArr = [uiImage]
        activityViewController.shareImage()
    }
    
    func shareImages(_ array: [UIImage]) {
        activityViewController.imageArr = array
        activityViewController.shareImage()
    }
}


class ActivityViewController : UIViewController {

    var imageArr = [UIImage]()

    @objc func shareImage() {
        let vc = UIActivityViewController(activityItems: imageArr, applicationActivities: [])
        vc.excludedActivityTypes =  [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        present(vc,
                animated: true,
                completion: nil)
        vc.popoverPresentationController?.sourceView = self.view
    }
}
