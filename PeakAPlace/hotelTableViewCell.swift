//
//  hotelTableViewCell.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 11/23/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit

class hotelTableViewCell: UITableViewCell {
    
    
  
    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hotelLocation: UILabel!
    
    func setHotel(theImage: UIImage, theName: String, theLocation: String) {
        hotelImage.image = theImage
        name.text = theName
        hotelLocation.text = theLocation
        
        
    }
}
