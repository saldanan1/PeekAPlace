//
//  HotelVideoCell.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 11/23/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit

class HotelVideoCell: UITableViewCell {

  
    @IBOutlet weak var hotelVideo: UIImageView!
    
   
    @IBOutlet weak var videoDescription: UILabel!
    
    func setTable(image: UIImage, text: String){
        hotelVideo.image = image
        videoDescription.text = text
    }
}
