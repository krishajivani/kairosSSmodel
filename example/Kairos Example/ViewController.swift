//
//  ViewController.swift

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var app_id = ""
    var app_key = ""

    let imagePicker = UIImagePickerController() //view controller type that deals with camera/video/etc.
    
    @IBOutlet var galleryEnrollTextfield: UITextField! //1st gallery textfield
    @IBOutlet var idEnrollTextfield: UITextField! //ID
    @IBOutlet weak var galleryRecognizeTextField: UITextField! //2nd gallery textfield
    //@IBOutlet var galTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self //.delegate specifies where you want the messages to go. Setting it to "self" sends the messaged to YOU!
        self.hideKeyboardWhenTappedAround() //hides keyboard when you tap anything else
    }
    
    func enroll(imageBase64: String) { //Takes a photo, finds the faces within it, and stores the faces into a gallery you create.
        var request = URLRequest(url: URL(string: "https://api.kairos.com/enroll")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue(app_id, forHTTPHeaderField: "app_id")
        request.setValue(app_key, forHTTPHeaderField: "app_key")
        
        let params : NSMutableDictionary? = [
            "image" : imageBase64,
            "gallery_name" : galleryEnrollTextfield.text!,
            "subject_id" : idEnrollTextfield.text!
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue); //passes pic info into the api request
        
        Alamofire.request(request).responseJSON { (response) in
            if((response.result.value) != nil) {
                let json = JSON(response.result.value!)
                
                let alert = UIAlertController(title: "Kairos", message: "\(json)", preferredStyle: UIAlertControllerStyle.alert) //this is where it's displayed in the popup!!!
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //photoURL: URL
    
//    func emotionAnalysis(photoURL: URL){
//        //the emotion analysis part!
//        if(galleryEnrollTextfield.text != "" && idEnrollTextfield.text != ""){
//            //let emotString = "https://api.kairos.com/v2/analytics/{" + "1" + "}"
////            print("ID BELOWWW:")
////            print(idEnrollTextfield.text!)
//            //var request = URLRequest(url: URL(string: emotString)!)
//            print("URL FROM FUNCTION: ")
//            print(photoURL)
//            //var emotString = "https://api.kairos.com/v2/media?" + imgName + "="
//            var emotString = "https://api.kairos.com/v2/media?source=" + photoURL.absoluteString
////            var url = URL(string: "https://api.kairos.com/v2/media?" + "https://cdn.mos.cms.futurecdn.net/DMUbjq2UjJcG3umGv3Qjjd-1024-80.jpeg" + "=")!
//            let url = URL(string: emotString)!
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            request.setValue(app_id, forHTTPHeaderField: "app_id")
//            request.setValue(app_key, forHTTPHeaderField: "app_key")
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let response = response {
//                    print(response)
//
//                    if let data = data, let body = String(data: data, encoding: .utf8) {
//                        DispatchQueue.main.async { // Correct
//                            self.galTextView.text = body
//                        }
//                    }
//                } else {
//                    print(error ?? "Unknown error")
//                }
//            }
//
//            task.resume()
//
//
//        }
//
//
//    }
    
    @IBAction func chooseEnrollButtonAction(_ sender: Any) { //when you click the first button
        if(galleryEnrollTextfield.text != "" && idEnrollTextfield.text != "") { //if both textfields are not empty, aka: have stuff in them
            imagePicker.allowsEditing = false //user is not allowed to edit any still image/movie in the imagePicker
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Kairos", message: "Enter all fields...", preferredStyle: UIAlertControllerStyle.alert) //popup alert that says to type in the textfields first!
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func recognizeButtonAction(_ sender: Any) { //second button, takes you to the camera controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cameraController = storyBoard.instantiateViewController(withIdentifier: "camera_view") as! CameraViewController
        cameraController.receivedGalleryName = galleryRecognizeTextField.text!
        self.present(cameraController, animated:true, completion:nil)
    }
    
//    @IBAction func listGalleries(_ sender: Any) {
//        var request = URLRequest(url: URL(string: "https://api.kairos.com/gallery/list_all")!)
//        request.httpMethod = "POST"
//
//        request.setValue(app_id, forHTTPHeaderField: "app_id")
//        request.setValue(app_key, forHTTPHeaderField: "app_key")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response {
//                print(response)
//
//                if let data = data, let body = String(data: data, encoding: .utf8) {
//                    print("BODYYYYY")
//                    //print(body.count)
//                    DispatchQueue.main.async { // Correct
//                        self.galTextView.text = body
//                    }
//                }
//            } else {
//                //print(error ?? "Unknown error")
//                //self.galTextView.text = error as! String ?? "Unknown error"
//                DispatchQueue.main.async { // Correct
//                    self.galTextView.text = "error occured"
//                }
//
//            }
//        }
//
//        task.resume()
//    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        //Tells the delegate that the user picked a still image or movie
            let imagedata = UIImageJPEGRepresentation(pickedImage, 1.0) //returns image data in JPEG format
            let base64String : String = imagedata!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) //converts the JPEG data to base64 format for storage and transfer purposes
            let imageStr : String = base64String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //fancier encoding
            
            enroll(imageBase64: imageStr)
            //emotionAnalysis(imageBase64: imageStr)
        }
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            print("IMAGE NAMEEE")
            print(imgName)
            print("IMAGE URLLL")
            print(imgUrl)
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print("PHOTO URLLLLL: ")
            print(photoURL)
            
            //emotionAnalysis(photoURL : photoURL)
            //emotionAnalysis(imgName: imgName)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //runs if the user cancels picking a pic- from the photo library in this case (presses that "cancel" button)
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController { //hides keyboard when outside is tapped
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
