//
//  ImageViewController.swift
//  WebDetection
//
//  Created by Tintash on 27/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    
    var image : UIImage!
    var ocrResult: OCRResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NEW: Resize the image to the screen size
        guard let resizedImage = resize(image: image, to: view.frame.size) else {
            fatalError("Error resizing image")
        }
        
        resultImageView.image = resizedImage
        
        detectBoundingBoxes(for: resizedImage)
    }
    
    private func resize(image: UIImage, to targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle.
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height + 1)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func detectBoundingBoxes(for image: UIImage) {
        NetworkEngine().detect(from: image) { ocrResult in
            self.ocrResult = ocrResult
            self.performSegue(withIdentifier: "ImageResponseSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let imageResponseViewController = segue.destination as? ImageResponseViewController {
            imageResponseViewController.ocrResult = ocrResult
        }
    }
}
