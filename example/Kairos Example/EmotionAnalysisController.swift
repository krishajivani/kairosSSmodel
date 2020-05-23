//
//  EmotionAnalysisController.swift
//
//  Created by Family Jivani on 5/13/20.

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EmotionAnalysisController: UIViewController {
    
    var app_id = ""
    var app_key = ""
    
    let imagePicker = UIImagePickerController() //view controller type that deals with camera/video/etc.

    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var emotionView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround() //hides keyboard when you tap anything else
    }
    
    @IBAction func goButton(_ sender: Any) {
        emotionAnalysis()
        setImage(from: urlField.text!)
        
    }
    
    func emotionAnalysis(){
        if(urlField.text != ""){
            
            var emotString = "https://api.kairos.com/v2/media?source=" + urlField.text!
            //            var url = URL(string: "https://api.kairos.com/v2/media?" + "https://cdn.mos.cms.futurecdn.net/DMUbjq2UjJcG3umGv3Qjjd-1024-80.jpeg" + "=")!
            let url = URL(string: emotString)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue(app_id, forHTTPHeaderField: "app_id")
            request.setValue(app_key, forHTTPHeaderField: "app_key")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let response = response {
                    print(response)
                    
                    if let data = data, let body = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async { // Correct
                            self.emotionView.text = body
                        }
                    }
                } else {
                    print(error ?? "Unknown error")
                }
            }
            
            task.resume()
            
            
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.faceImageView.image = image
            }
        }
    }
    
}
