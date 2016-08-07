//
//  HelperFunctions.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/7/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation

class HelperFunctions {
    
    
    // MARK: Get Folder/File Location
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
}