//
//  NetworkEngine.swift
//  WebDetection
//
//  Created by Tintash on 28/08/2019.
//  Copyright © 2019 Tintash. All rights reserved.
//

/*
 curl -X POST      -H "Authorization: Bearer "$(gcloud auth application-default print-access-token)      -H "Content-Type: application/json; charset=utf-8"      --data "{
 'requests': [
 {
 'image': {
 'content': '$(cat sample.jpg | base64)'
 },
 'features': [
 {
 'type': 'TEXT_DETECTION'
 }
 ]
 }
 ]
 }" "https://vision.googleapis.com/v1/images:annotate?key=AIzaSyBQQ2D65rTYIMQ2CBzY5G64lsV3vUCf0kY"
 
 */

import Foundation
import Alamofire

class NetworkEngine {
    private let apiKey = "AIzaSyBQQ2D65rTYIMQ2CBzY5G64lsV3vUCf0kY"
    private var apiURL : URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping(OCRResult?)->Void) {
        guard let base64EncodedImage = base64EncodingImage(image) else {
            print("Error while base64 encoding image")
            completion(nil)
            return
        }
        callGoogleVisionAPI(with: base64EncodedImage, completion: completion)
    }
    
    func callGoogleVisionAPI(with base64EncodedImage: String?, completion: @escaping(OCRResult?)->Void) {
        
        let parameters : Parameters = [
            "requests": [
                [
                    "image": [
                        "content" : base64EncodedImage
                    ],
                    "features": [
                        [
                            "type" : "TEXT_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        
        let headers : HTTPHeaders = [
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? ""
        ]
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let dataArray = value as? [String:Any] else {
                    completion(nil)
                    return
                }
                
                do {
                    let jsonData    = try JSONSerialization.data(withJSONObject: dataArray)
                    let decoder     = JSONDecoder()
                    let ocrResponse = try decoder.decode(GoogleCloudOCRResponse.self, from: jsonData)
                    completion(ocrResponse.responses[0])
                } catch{
                    print(error.localizedDescription)
                    completion(nil)
                }
                
            case .failure(let error):
                completion(nil)
                print(error.localizedDescription)
                return
            }
        }
        
    }
    
    func base64EncodingImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
