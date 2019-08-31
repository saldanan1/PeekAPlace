//
//  VideoTypeViewController.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 12/2/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import Photos

class VideoTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var tagsIdentifier: String = ""
    var escapedHotelName: String = "not working"
    var currHotelName: String = "not working"
    var roomTypes = ["Bedroom", "Bathroom", "Lobby", "Gym", "Pool"]
    var roomVideos: [AVAsset?] = [AVAsset?](repeating: nil, count: 5)
    var currentRoom: RoomTypes = RoomTypes.Bedroom
    
    @IBOutlet weak var videoTypeTable: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var mergeButton: UIButton!

    func setupTableView() {
        videoTypeTable.dataSource = self
        videoTypeTable.delegate = self
        
    }
    @IBAction func unwindOutOfTags(unwindSegue: UIStoryboardSegue){
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(checkPermission()){
            if savedPhotosAvailable() {
                self.currentRoom = RoomTypes(rawValue: indexPath.row)!
                VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoTypeCell") as! videoTypeTableViewCell
        
        let cellTitle = roomTypes[indexPath.row]
//        print(cellTitle)
        cell.setRoomTypeCell(cellName: cellTitle)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Hotel Name:")
        print(currHotelName)
        escapedHotelName = currHotelName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    @IBAction func merge(_ sender: AnyObject) {
        var videosToMerge: [AVAsset] = []
        
        for video in self.roomVideos {
            if video != nil {
                videosToMerge.append(video!)
            }
        }
        
        if videosToMerge.count <= 0 {
            return
        }
        
        //    activityMonitor.startAnimating()
        
        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        // 2 - Create two video tracks
        
        //        var videoTracks: [AVMutableCompositionTrack] = []
        var currDuration: CMTime = CMTimeMake(0, 0)
        guard
            let track = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            else { return }
        
        for video in videosToMerge {
            
            do {
                try track.insertTimeRange(CMTimeRangeMake(kCMTimeZero, video.duration), of: video.tracks(withMediaType: AVMediaType.video)[0], at: currDuration)
                
            } catch {
                print("Failed to add video to track!")
                return
            }
            currDuration = CMTimeAdd(currDuration, video.duration)
        }
        
        
        
        //    // 3 - Audio track
        //    if let loadedAudioAsset = audioAsset {
        //        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: 0)
        //        do {
        //            try audioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero,
        //                                                            CMTimeAdd(firstAsset.duration,
        //                                                                      secondAsset.duration)),
        //                                            of: loadedAudioAsset.tracks(withMediaType: AVMediaType.audio)[0] ,
        //                                            at: kCMTimeZero)
        //        } catch {
        //            print("Failed to load Audio track")
        //        }
        //    }
        
        
        
        // 4 - Get path
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        let date = dateFormatter.string(from: Date())
        let url = documentDirectory.appendingPathComponent("\(escapedHotelName)-\(date).mov")
        
        // 4.5 - Save to UserDefaults
        
        
        let dataStore = UserDefaults.standard
        let encodedURL: Data = NSKeyedArchiver.archivedData(withRootObject: url.absoluteString)
        
        // Figure out if there are other videos for this hotel
        let baseName: String = "\(escapedHotelName)-video-"
        var thisName: String = ""
        for i in 0..<5 {
            let currName = "\(baseName)\(i)"
            if dataStore.object(forKey: currName) == nil {
                thisName = currName
                break
            }
        }
        if thisName == "" {
            thisName = "\(baseName)0"
        }
        //remember to clear currtags
        self.tagsIdentifier = "\(thisName)-tags"
        
        print(thisName)
        
//        dataStore.set(encodedURL, forKey: "Hotel Name-video-0")
        dataStore.set(encodedURL, forKey: thisName)
        
        // 5 - Create Exporter
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        
        // 6 - Perform the Export
        exporter.exportAsynchronously() {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
        
    }
    
    @objc func exportDidFinish(_ session: AVAssetExportSession) {
        
        // Cleanup assets
        roomVideos = [AVAsset?](repeating: nil, count: 5)
        
        //        DispatchQueue.main.sync{
        //            activityMonitor.stopAnimating()
        //        }
        //        activityMonitor.stopAnimating()
        //        firstAsset = nil
        //        secondAsset = nil
        //        audioAsset = nil
        
        guard
            session.status == AVAssetExportSessionStatus.completed,
            let outputURL = session.outputURL
            else {
                return
        }
        
        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
            }) { saved, error in
                let success = saved && (error == nil)
                let title = success ? "Success" : "Error"
                let message = success ? "Video saved" : "Failed to save video"
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                //                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Ensure permission to access Photo Library
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    saveVideoToPhotos()
                }
                else { print("Photo Library UNAUTHORIZED") }
            }
        } else {
            saveVideoToPhotos()
            let dataStore = UserDefaults.standard
            if dataStore.object(forKey: "currTags") !=  nil {
                let decodedCurrTags = dataStore.object(forKey: "currTags") as! Data
                dataStore.set(decodedCurrTags, forKey: self.tagsIdentifier)
            }
            UIApplication.shared.sendAction(doneButton.action!, to: doneButton.target, from: self, for: nil)
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
            print("Access is granted by user")
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
            print("User does not have access to photo album.")
            return false;
        case .denied:
            print("User has denied the permission.")
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension VideoTypeViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL
            else { return }
        
        self.roomVideos[currentRoom.rawValue] = AVAsset(url: url)
        let message = self.roomTypes[currentRoom.rawValue] + "video loaded!"
        //        self.loaded = true
        
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

