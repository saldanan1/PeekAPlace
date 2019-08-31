//
//  videoTypeTableViewCell.swift
//  PeakAPlace
//
//  Created by Ana Boyer on 12/2/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit

class videoTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTypeLabel: UILabel!
    
    func setRoomTypeCell(cellName: String) {
        videoTypeLabel.text = cellName
        print(cellName)
    }

}
