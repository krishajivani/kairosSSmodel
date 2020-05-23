# Kairos in Swift

## Project Summary
The Jivy! Security System Model is a bare-bones model showing the various ways Kairos SDK/API can be utilized for human detection and recognition. Many Kairos features for still image manipulation are used. Live video facial recognition and analysis is currently in progress!

<img width="200" alt="MainFR" src="https://user-images.githubusercontent.com/45325370/82722915-3f554d00-9c90-11ea-8973-242a0ffb488e.png">  <img width="200" alt="EmotionFR" src="https://user-images.githubusercontent.com/45325370/82722944-85121580-9c90-11ea-8f0f-fe8fe5456219.png"> <img width="411" alt="GalleriesFR" src="https://user-images.githubusercontent.com/45325370/82722950-922f0480-9c90-11ea-8d8d-c5ce16d98f9f.png">

## Features (current)
Used Kairos for iOS to implement facial recognition and emotion analysis features. Specific implementations: <br>
Tab Bar Controller- Main:
  * Enroll
  * Recognize 
  
Tab Bar Controller- Galleries:  
  * Gallery- List All
  * Gallery- View
  * Gallery- Remove
  * Gallery- Remove Subject 

Tab Bar Controller- Emotion Analysis:
  * POST /media  
  

## Supporting pods:
Alamofire - [https://github.com/Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
<br/>
SwiftyJSON - [https://github.com/SwiftyJSON/SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

<br>

## Usage:
Put in your app\_id and app\_key in the ViewController.swift, CameraViewController.swift, GalleriesViewController.swift, and EmotionAnalysisController.swift


```swift
var app_id = "";
var app_key = "";
```

<br>

## Getting App ID and Key:
Get app\_id and app\_key from:

[https://developer.kairos.com/signup](https://developer.kairos.com/signup)

<br>

## Projects credited:
https://github.com/shanezzar/Kairos-Example-using-iOS-Swift <br>
_This application incorporates Shanezzar's demo_

<br>


Feel free to use this project for learning purposes! <br>



