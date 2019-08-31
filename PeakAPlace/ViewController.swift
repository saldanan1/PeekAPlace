//
//  ViewController.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 11/23/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    var keyword = ""
    var theCityName = "St. Louis"
    var geoID = "44881"
    var theData:[Info] = []
    var theImageCache: [UIImage] = []
    
    var hotelName: String = ""
    var rating: String = ""
    var numberOfReviews: String = ""
    var hotelImage: UIImage?
    
 
   let locationManager = CLLocationManager()
    
    @IBOutlet weak var hotelSearch: UITextField!
    
   
    @IBAction func keyEntered(_ sender: Any) {
    
    let text: String = hotelSearch.text!
        if (hotelSearch.text?.count)! > 0 {
            keyword = text
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyword = hotelSearch.text!
        searchHotels(hotelSearch)
        dismissKeyboard()
        return true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func searchHotels(_ sender: Any) {
        self.activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        setupTableView()
        
        theData = getHotelList(theGeoID: self.geoID)
        var newList: [Info] = []
        for item in theData{
            if item.name!.localizedCaseInsensitiveContains(self.hotelSearch.text!){
                newList.append(item)
            }
        }
        if newList.isEmpty{
            var newHotel: Info = Info(name: "", rating: "", pic: "", rank: "", num_reviews: "")
            newHotel.pic = "https://cdn2.vectorstock.com/i/1000x1000/10/81/error-404-glitch-text-vector-18841081.jpg"
            newList.append(newHotel)
        }
        if hotelSearch.text!.caseInsensitiveCompare("") == ComparisonResult.orderedSame{
            newList = getHotelList(theGeoID: self.geoID)
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.theData = newList
            self.theImageCache = []
            self.cacheImages(hotelList: newList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var indicator = UIActivityIndicatorView()
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    @IBOutlet weak var selectCityButton: UIButton!
    
    @IBAction func showCitySelector(_ sender: Any) {
//    let popOverVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "citySelection") as! citySelectionViewController
//        self.addChildViewController(popOverVC)
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        popOverVC.didMove(toParentViewController: self)
    }
  
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCityButton.setTitle(theCityName, for: .normal)
        hotelSearch.delegate = self
        
        self.activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        self.setupTableView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForTableView()
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchDataForTableView() {
        theData = getHotelList(theGeoID: geoID)
    }
    
    func getHotelList(theGeoID: String)->[Info]{
        var listOfHotels: [Info] = []
        let url = URL(string: "https://api.tripadvisor.com/api/partner/2.0/location/\(theGeoID)/hotels?key=856EE70B9C724C1E90505B582B267DB8&limit=50")!
        let data: Data = try! Data(contentsOf: url)
        let dataResults = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let hotelsInCity = dataResults["data"] as! [[String: Any]]
        for item in hotelsInCity{ //initiates new hotel for each item in list, adds NAME, RATING, RANK, PIC, NUM_REVIEWS
            var hotel = Info(name: "",  rating: "", pic: "", rank: "", num_reviews: "")
            hotel.name = item["name"] as! String?
            let rankingData = item["ranking_data"] as! [String: Any]
            hotel.rank = rankingData["ranking_string"] as! String?
            hotel.rating = item["rating"] as! String?
            hotel.num_reviews = item["num_reviews"] as! String?
            print(hotel)
            //This is all to get the url for the photo
            let photo = item["photo"] as! [String: Any]
            let images = photo["images"] as! [String: Any]
            let size = images["original"] as! [String: Any]
            hotel.pic = size["url"] as! String?
            
            listOfHotels.append(hotel)
        }
        return listOfHotels
    }

    func cacheImages(hotelList: [Info]){
        for item in hotelList{
            let url = URL(string: item.pic!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
        }
    }
    
    func cacheImages() {
        for item in theData {
            let url = URL(string: item.pic!)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            theImageCache.append(image!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell") as! hotelTableViewCell
        self.tableView.rowHeight = 100
        let hotelName = theData[indexPath.row].name
        let hotelImage = theImageCache[indexPath.row]
        
        let hotelRank = theData[indexPath.row].rank
        cell.setHotel(theImage: hotelImage, theName: hotelName!, theLocation: hotelRank!)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let someLocation = locations[0]
        let howRecent = someLocation.timestamp.timeIntervalSinceNow
        locationManager.stopUpdatingLocation()
        if (howRecent < -10) {return}
        let accuracy = someLocation.horizontalAccuracy
        locationManager.stopUpdatingLocation()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hotelName = self.theData[indexPath.row].name!
        rating = self.theData[indexPath.row].rating!
        numberOfReviews = self.theData[indexPath.row].num_reviews!
        hotelImage = self.theImageCache[indexPath.row]
        self.performSegue(withIdentifier: "detailedSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? ViewController2 {
        secondViewController.hotelName = hotelName
        secondViewController.rating = rating
        secondViewController.numberOfReviews = numberOfReviews
        secondViewController.hotelImage = self.hotelImage
        }
    }
}


