//
//  FilterViewController.swift
//  PeakAPlace
//
//  Created by Noah Saldaña on 12/2/18.
//  Copyright © 2018 Ana Boyer. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var yellowColor: UIColor!
    var selectColor: UIColor!
    
    @IBOutlet weak var poolView: UIView!
    @IBOutlet weak var bathroomView: UIView!
    @IBOutlet weak var bedroomView: UIView!
    @IBOutlet weak var lobbyView: UIView!
    @IBOutlet weak var gymView: UIView!
    @IBOutlet weak var extraView: UIView!
    
    @IBOutlet weak var cleanView: UIView!
    @IBOutlet weak var goodServiceView: UIView!
    @IBOutlet weak var greatStayView: UIView!
    @IBOutlet weak var kindStaffView: UIView!
    @IBOutlet weak var helpfulView: UIView!
    @IBOutlet weak var greatTimeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yellowColor = poolView.backgroundColor
        selectColor = UIColor.green
        //hotelname-i-tag
    }
    struct testObject {
        let name: String!
        var tag: [String]
    }
    var test = testObject(name: "test", tag: [])
    //categories
    @IBAction func poolPress(_ sender: Any) {
        if (poolView.backgroundColor != yellowColor){
            poolView.backgroundColor = yellowColor
        }else{poolView.backgroundColor = selectColor}
    }
    @IBAction func bathroomPress(_ sender: Any) {
        if(bathroomView.backgroundColor != yellowColor){
            bathroomView.backgroundColor = yellowColor
        }else{bathroomView.backgroundColor = selectColor}
    }
    @IBAction func bedroomPress(_ sender: Any) {
        if (bedroomView.backgroundColor != yellowColor){
            bedroomView.backgroundColor = yellowColor
        }else{bedroomView.backgroundColor = selectColor}
    }
    @IBAction func lobbyPress(_ sender: Any) {
        if (lobbyView.backgroundColor != yellowColor){
            lobbyView.backgroundColor = yellowColor
        }else{lobbyView.backgroundColor = selectColor}
    }
    @IBAction func gymPress(_ sender: Any) {
        if (gymView.backgroundColor != yellowColor){
            gymView.backgroundColor = yellowColor
        }else{gymView.backgroundColor = selectColor}
    }
    @IBAction func extraPress(_ sender: Any) {
        if (extraView.backgroundColor != yellowColor){
            extraView.backgroundColor = yellowColor
        }else{extraView.backgroundColor = selectColor}
    }
    //tags
    @IBAction func cleanPress(_ sender: Any) {
        if (cleanView.backgroundColor != yellowColor){
            cleanView.backgroundColor = yellowColor
        }else{cleanView.backgroundColor = selectColor}
    }
    @IBAction func goodServicePress(_ sender: Any) {
        if (goodServiceView.backgroundColor != yellowColor){
            goodServiceView.backgroundColor = yellowColor
        }else{goodServiceView.backgroundColor = selectColor}
    }
    @IBAction func greatStayPress(_ sender: Any) {
        if (greatStayView.backgroundColor != yellowColor){
            greatStayView.backgroundColor = yellowColor
        }else{greatStayView.backgroundColor = selectColor}
    }
    @IBAction func kindStaffPress(_ sender: Any) {
        if (kindStaffView.backgroundColor != yellowColor){
            kindStaffView.backgroundColor = yellowColor
        }else{kindStaffView.backgroundColor = selectColor}
    }
    @IBAction func helpfulPress(_ sender: Any) {
        if (helpfulView.backgroundColor != yellowColor){
            helpfulView.backgroundColor = yellowColor
        }else{helpfulView.backgroundColor = selectColor}
    }
    @IBAction func greatTimePress(_ sender: Any) {
        if (greatTimeView.backgroundColor != yellowColor){
            greatTimeView.backgroundColor = yellowColor
        }else{greatTimeView.backgroundColor = selectColor}
    }
    
    
    @IBAction func buttonPress(_ sender: Any) {
        if let buttonTitle = (sender as AnyObject).title(for: .normal) {
            if !(test.tag.contains(buttonTitle)){
                test.tag.append(buttonTitle)
                print(test.tag)
            }
        }
    }
    /*@IBAction func colorChange(_ sender: UIButton) {
        let initialColor = UIColor.init(red: (255/255), green: (181/255), blue: (49/255), alpha: 1.0)
        print(sender.backgroundColor)
        if let buttonColor = sender.backgroundColor{
            if (initialColor != buttonColor){
                sender.backgroundColor == initialColor
            }
            else{
                sender.backgroundColor == UIColor.blue
            }
            //r:255 g:181 b:49
        }
        
    }*/
    @IBAction func resetFilter(_ sender: Any) {
        test.tag = [];
        //clear categories
        poolView.backgroundColor = yellowColor
        bathroomView.backgroundColor = yellowColor
        bedroomView.backgroundColor = yellowColor
        lobbyView.backgroundColor = yellowColor
        gymView.backgroundColor = yellowColor
        extraView.backgroundColor = yellowColor
        //clear tags
        cleanView.backgroundColor = yellowColor
        goodServiceView.backgroundColor = yellowColor
        greatStayView.backgroundColor = yellowColor
        kindStaffView.backgroundColor = yellowColor
        helpfulView.backgroundColor = yellowColor
        greatTimeView.backgroundColor = yellowColor
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
