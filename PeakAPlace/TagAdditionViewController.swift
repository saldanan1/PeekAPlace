//
//  TagAdditionViewController.swift
//  PeakAPlace
//
//  Created by Noah Saldaña on 12/2/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit

class TagAdditionViewController: UIViewController {

    @IBOutlet weak var poolButton: UIButton!
    var tagHolderArray: [String] = []
    var yellowColor: UIColor!
    var selectColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yellowColor = poolButton.backgroundColor
        selectColor = UIColor.green
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPress(_ sender: Any) {
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            if !(tagHolderArray.contains(buttonTitle)){
                tagHolderArray.append(buttonTitle)
                print(tagHolderArray)
            }
        }
    }
    @IBAction func resetAll(_ sender: Any) {
        tagHolderArray = []
    }
    @IBAction func applyTags(_ sender: Any) {
        let dataStore = UserDefaults.standard
        let encodedURL: Data = NSKeyedArchiver.archivedData(withRootObject: tagHolderArray)
        dataStore.set(encodedURL, forKey: "currTags")
    }
}
