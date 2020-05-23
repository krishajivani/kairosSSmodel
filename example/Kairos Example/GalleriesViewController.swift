
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class GalleriesViewController: UIViewController {
    var app_id = ""
    var app_key = ""

    let imagePicker = UIImagePickerController() //view controller type that deals with camera/video/etc.
    @IBOutlet weak var removeTxtField: UITextField!
    @IBOutlet weak var galleriesTxtView: UITextView!
    @IBOutlet weak var subjectsTxtView: UITextView!
    @IBOutlet weak var inputGalView: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayGalleries()
        self.hideKeyboardWhenTappedAround() //hides keyboard when you tap anything else
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        inputGalView.text = ""
        removeTxtField.text = ""
        subjectsTxtView.text = ""
        displayGalleries()
        
    }
    
    
    func displayGalleries(){
        var request = URLRequest(url: URL(string: "https://api.kairos.com/gallery/list_all")!)
        request.httpMethod = "POST"
        
        request.setValue(app_id, forHTTPHeaderField: "app_id")
        request.setValue(app_key, forHTTPHeaderField: "app_key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
                
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("BODYYYYY")
                    //print(body.count)
                    DispatchQueue.main.async { // Correct
                        self.galleriesTxtView.text = body
                    }
                }
            } else {
                //print(error ?? "Unknown error")
                //self.galTextView.text = error as! String ?? "Unknown error"
                DispatchQueue.main.async { // Correct
                    self.galleriesTxtView.text = "error occured"
                }
                
            }
        }
        
        task.resume()
    }
    
    
    @IBAction func displaySubjects(_ sender: Any) {
        listSubjects()
        
    }
    
    func listSubjects(){
        print("Hi!")
        if (inputGalView.text != "") {
            let url = URL(string: "https://api.kairos.com/gallery/view")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(app_id, forHTTPHeaderField: "app_id")
            request.addValue(app_key, forHTTPHeaderField: "app_key")
            
            let params : NSMutableDictionary? = [
                "gallery_name" : inputGalView.text!,
            ]
            
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            
            Alamofire.request(request).responseJSON { (response) in
                if((response.result.value) != nil) {
                    let json = JSON(response.result.value!)
                    
                    self.subjectsTxtView.text = "\(json)"
                }
            }
            
        }
    }
    
    @IBAction func removeGallery(_ sender: Any) {
        if (removeTxtField.text != "") {
            let url = URL(string: "https://api.kairos.com/gallery/remove")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(app_id, forHTTPHeaderField: "app_id")
            request.addValue(app_key, forHTTPHeaderField: "app_key")
            
            let params : NSMutableDictionary? = [
                "gallery_name" : removeTxtField.text!,
            ]
            
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            
            Alamofire.request(request).responseJSON { (response) in
                if((response.result.value) != nil) {
                    //let json = JSON(response.result.value!)
                    
                    //self.subjectsTxtView.text = "\(json)"
                    self.displayGalleries()
                    self.subjectsTxtView.text = ""
                }
            }
            
            
        }
        
        
        //listSubjects()

    }

    @IBAction func removeSubject(_ sender: Any) {
        if (removeTxtField.text!.contains(",") && removeTxtField.text!.count >= 3) {
            let url = URL(string: "https://api.kairos.com/gallery/remove_subject")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(app_id, forHTTPHeaderField: "app_id")
            request.addValue(app_key, forHTTPHeaderField: "app_key")
            
            var galName = ""
            var subName = ""
            let comboString : String = removeTxtField.text!
            
            let commaIndex = comboString.distance(from: comboString.startIndex, to: comboString.index(of: ",")!)
            print("COMMA INDEX:")
            print(commaIndex)
            
            galName = comboString[0 ..< commaIndex]
            subName = comboString[commaIndex + 1 ..< comboString.length + 1]
            
            print("GALNAME:")
            print(galName)
            print("SUBNAME:")
            print(subName)
            let params : NSMutableDictionary? = [
                "gallery_name" : galName,
                "subject_id" : subName
            ]
            
            let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
            
            Alamofire.request(request).responseJSON { (response) in
                if((response.result.value) != nil) {
                    //let json = JSON(response.result.value!)
                    
                    //self.subjectsTxtView.text = "\(json)"
                    self.displayGalleries()
                    self.listSubjects()
                }
            }
            
            
        }
        
        

    }
    
    
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

