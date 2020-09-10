//
//  TitleCollectionViewCell.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/27/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class TitleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backlabel: UIImageView!
    @IBOutlet weak var beforeimge: UIImageView!
    
    @IBOutlet weak var taphold: UIButton!
    @IBOutlet weak var titleback: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var viewslabel: UILabel!
    @IBOutlet weak var tapdown: UIButton!
    @IBOutlet weak var tapup: UIButton!
    @IBOutlet weak var upvoteslabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    
    var tapped = true
    @IBOutlet weak var leadinglabel: UILabel!
    
    func logPhotoTapped(referrer : String) {
              AppEvents.logEvent(AppEvents.Name(rawValue: "photo pressed"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
          }
        
    
    @IBAction func tapHold(_ sender: Any) {
        
        logPhotoTapped(referrer: referrer)
        
        if tapped {
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            leadinglabel.text = "Tap to see photo with preset"
            self.beforeimge.alpha = 1
            self.titleImage.alpha = 0
            
            tapped = false
            
        } else {
            
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            self.beforeimge.alpha = 0
            self.titleImage.alpha = 1
            leadinglabel.text = "Tap to see original photo"
            tapped = true
            
        }
        
        
        
    }
}
