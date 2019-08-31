//
//  ViewController2.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 11/23/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
import AVKit
import Photos

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var testAsset: AVAsset?
    var loaded: Bool = false
    var hotelName: String = ""
    var hotelImage: UIImage?
    var rating: String = ""
    var numberOfReviews: String = ""
   
    @IBOutlet weak var selectedHotelImage: UIImageView!
    @IBOutlet weak var selectedHotelName: UILabel!
    @IBOutlet weak var selectedHotelRating: UILabel!
    @IBOutlet weak var selectedHotelNumReviews: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
   
    @IBAction func showAddPopUp(_ sender: Any) {
    
        let popOverAdd = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "AddVC") as! AddViewController
        self.addChildViewController(popOverAdd)
        popOverAdd.view.frame = self.view.frame
//        popOverAdd.currHotelName = self.selectedHotelName.text!
        popOverAdd.currHotelName = self.hotelName
        self.view.addSubview(popOverAdd.view)
        popOverAdd.didMove(toParentViewController: self)
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        videoTable.reloadData()
    }
    @IBOutlet weak var videoTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func setupVideoTable() {
        videoTable.dataSource = self
        videoTable.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelVideoCell") as! HotelVideoCell
        self.videoTable.rowHeight = 150
        let videoImage = UIImage(named:"Todd")!.alpha(0.5)
        let hotelDescription = ""
        
        cell.setTable(image: videoImage, text:hotelDescription)
        
        var url: String
        let dataStore = UserDefaults.standard
        let hotelName = self.selectedHotelName.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let testString: String = "\(hotelName)-video-\(indexPath.row)"
        if dataStore.object(forKey: "\(hotelName)-video-\(indexPath.row)") != nil{
            let decodedAsset = dataStore.object(forKey: "\(hotelName)-video-\(indexPath.row)") as! Data
            url = NSKeyedUnarchiver.unarchiveObject(with: decodedAsset) as! String
            
            let videoURL = URL(string: url)
            let testThumbnail = thumbnailForVideoAtURL(url: videoURL!)
            cell.setTable(image: testThumbnail!, text: "")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(checkPermission()){
            if savedPhotosAvailable() {
                var url: String
                let dataStore = UserDefaults.standard
                let hotelName = self.hotelName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                if dataStore.object(forKey: "\(hotelName)-video-\(indexPath.row)") != nil{
                    let decodedAsset = dataStore.object(forKey: "\(hotelName)-video-\(indexPath.row)") as! Data
                    url = NSKeyedUnarchiver.unarchiveObject(with: decodedAsset) as! String
                    
                    let videoURL = URL(string: url)
                    
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        }
    }
    

    override func viewDidLoad() {
        self.setupVideoTable()
        super.viewDidLoad()
        selectedHotelName.text = self.hotelName
        selectedHotelRating.text = "Rating: \(self.rating)"
        selectedHotelNumReviews.text = "Number of Reviews: \(self.numberOfReviews)"
        selectedHotelImage.image = self.hotelImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dataStore = UserDefaults.standard
        let formattedHotelName = self.hotelName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        if dataStore.object(forKey: "\(formattedHotelName)-video-0-tags") !=  nil {
            let decodedCurrTags = dataStore.object(forKey: "\(formattedHotelName)-video-0-tags") as! Data
            let currTags = NSKeyedUnarchiver.unarchiveObject(with: decodedCurrTags) as! [String]
        }
    }
    
    func savedPhotosAvailable() -> Bool {
        guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return true }
        
        let alert = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        return false
    }
    
    func checkPermission() -> Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            return true
        case .notDetermined:
            var authorized = false
            PHPhotoLibrary.requestAuthorization({ (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    authorized = true
                }
            })
            return authorized
        case .restricted:
            return false;
        case .denied:
            return false
        }
    }
    
    private func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ViewController2: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL
            else { return }
        
        self.testAsset = AVAsset(url: url)
        let message = "video loaded!"
        self.loaded = true
        
        //        if loadingAssetOne {
//            message = "Video one loaded"
//            firstAsset = avAsset
//
//            let dataStore = UserDefaults.standard
//
//            //        if dataStore.object(forKey: "favoriteMovies") != nil{
//            //            let decodedFavorites = dataStore.object(forKey: "favoriteMovies") as! Data
//            //            favoriteMovies = NSKeyedUnarchiver.unarchiveObject(with: decodedFavorites) as! Array
//            //        }
//            let encodedFavorites: Data = NSKeyedArchiver.archivedData(withRootObject: url.absoluteString)
//
//            //        // Load a video
//            //        let test: AVAsset = AVAsset(url: URL(string: url.absoluteString)!)
//
//            dataStore.set(encodedFavorites, forKey: "firstAsset")
//
//        } else {
//            message = "Video two loaded"
//            secondAsset = avAsset
//        }
        let alert = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
