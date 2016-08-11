//
//  SoundOption.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/9/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation

class SoundOption : NSObject {
    
    
    var name : String!
    var speedRate : Float?
    var pitchRate : Float?
    var imagePath : String!
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.name = decoder.decodeObjectForKey("name") as! String
        self.speedRate = decoder.decodeObjectForKey("speedRate") as? Float
        self.pitchRate = decoder.decodeObjectForKey("pitchRate") as? Float
        self.imagePath = decoder.decodeObjectForKey("imagePath") as! String
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(speedRate, forKey: "speedRate")
        aCoder.encodeObject(pitchRate, forKey: "pitchRate")
        aCoder.encodeObject(imagePath, forKey: "imagePath")
    }
    
    init(name: String, speedRate: Float?, pitchRate: Float?, imagePath : String) {
        super.init()
        self.name = name
        self.speedRate = speedRate
        self.pitchRate = pitchRate
        self.imagePath = imagePath
    }
    
    override var description: String {
        return "name: \(name)" +
            "speed right: \(speedRate)" +
            "pitch rare : \(pitchRate)" +
            "image path: \(imagePath)"     }
    
}