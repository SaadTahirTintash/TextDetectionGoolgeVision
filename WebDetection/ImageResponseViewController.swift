//
//  ImageResponseViewController.swift
//  WebDetection
//
//  Created by Tintash on 28/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

class ImageResponseViewController: UIViewController {

    @IBOutlet weak var resultLabel : UILabel!
    
    var ocrResult: OCRResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareResult()
    }
    
    func prepareResult() {
        var resultString: String = ""
        
        guard let ocrResult = ocrResult else {
            print("OCR Result Failure!")
            return
        }
        
        for annotation in ocrResult.annotations {
            resultString.append("Text: \(annotation.text)\n")
//            for vertex in annotation.boundingBox.vertices {
//                resultString.append("Vertex")
//                resultString.append("X: \(vertex.x!)\n")
//                resultString.append("Y: \(vertex.y!)\n")
//            }
            
        }
        print("Result: \(resultString)")
        resultLabel.text = resultString
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
