//
//  SoundOptionView.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/9/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation
import UIKit

class SoundOptionView : UIView {
    
    private var optionImage: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    init(frame: CGRect, imagePath: String) {
        super.init(frame: frame)
        commonInit()
        
        NSNotificationCenter.defaultCenter().postNotificationName("LVCLoadImageNotification", object: self, userInfo: ["imageView":optionImage, "imageName" : imagePath])
    }
    
    func commonInit() {
        backgroundColor = UIColor.blackColor()
        optionImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        addSubview(optionImage)
        optionImage.addObserver(self, forKeyPath: "image", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func highlightAlbum(didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.clearColor()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let newValue: AnyObject? = change?[NSKeyValueChangeNewKey]
        
        if let _: AnyObject = newValue {
            if keyPath == "image" {
                
            }
        }
    }
    
    deinit {
        optionImage.removeObserver(self, forKeyPath: "image")
    }
}
