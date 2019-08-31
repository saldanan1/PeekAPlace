//
//  AddViewController.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 11/23/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
import AVKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currHotelName: String = "not working"
    
    override func viewWillAppear(_ animated: Bool) {
        print(currHotelName)
    }
    
    @IBOutlet weak var uploadVideoButton: UIButton!
    
    
    @IBOutlet weak var takeVideoButton: UIButton!
   
    @IBOutlet weak var cancelButton: UIButton!
   
    @IBAction func cancelUpload(_ sender: Any) {
    self.view.removeFromSuperview()
    }
    @IBOutlet weak var popupBackground: UIView!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        super.viewDidLoad()
        self.view.layer.cornerRadius = 5;
        self.view.layer.masksToBounds = true;
        uploadVideoButton.layer.cornerRadius = 10;
        takeVideoButton.layer.cornerRadius = 10;
        cancelButton.layer.cornerRadius = 10;
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = self.currHotelName
        print("Data = " + data)
//        let testViewController = segue.destination as? VideoTypeViewController
//        testViewController.currHotelName = data
        if let destinationNavViewController = segue.destination as? UINavigationController {
            if let destinationViewController = destinationNavViewController.childViewControllers.first as? VideoTypeViewController {
                print("Data = " + data)
                destinationViewController.currHotelName = data
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takeVideo(_ sender: Any) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else {
                return
        }
        
        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(
            url.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

